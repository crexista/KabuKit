//
//  BaseScene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © crexista. All rights reserved.
//

import Foundation

/**
 TODO 後でScreenという名前に変更する
 
 */
public protocol BaseScene : class {
    
    /**
     画面表示をセットアップします
     
     */
    func setup<S, C>(sequence:AnyObject, stage: S, argument: C, container: SceneManager, scenario: Scenario?)
    
    /**
     画面表示周りを破棄します
     
     - returns: Bool
       - true 表示のクリアに成功
       - false 表示のクリアに失敗
     */
    func clear<S>(stage: S) -> Bool
}

public class SceneManager {
    
    // key: Scene
    private static var managers: NSMapTable<AnyObject, SceneManager> = NSMapTable.weakToWeakObjects()
    
    private static let managerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    
    // key: Scene, value: (director, argument) のタプルか (director, argument, actor) のタプル
    private var sceneHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    // Sceneをスタックし、現在有効なSceneを取り出せるようにします
    private var scenes: [BaseScene]
    
    // frameHashMap, scens その両方を操作する際に必要となるdispatch queue
    private let sceneQueue: DispatchQueue
    
    /**
     現在有効(ユーザに表示しているであろう)Sceneを返します
     ## 注意 ##
     内部的にsyncをしているため呼びだす際にsyncを使う必要はありません
     
     */
    internal var currentScene: BaseScene? {
        return sceneQueue.sync {
            return self.scenes.last
        }
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func release(frame: BaseScene) {
        sceneQueue.async(flags: .barrier) {
            
            // SceneManagerはstaticであり違うスレッドからリクエストされる可能性があるため2重ロックにしてます
            SceneManager.managerQueue.async(flags: .barrier) {
                SceneManager.managers.removeObject(forKey: frame)
            }
            _ = self.scenes.popLast()
            self.sceneHashMap.removeObject(forKey: frame)
        }
    }
    
    /**
    Sceneをキーとして、それに紐づくDirectorとArgumentオブジェクトを紐付けます
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func set(frame: BaseScene, stuff: AnyObject) {
        sceneQueue.async(flags: .barrier) {
            self.sceneHashMap.setObject(stuff, forKey: frame)
            self.scenes.append(frame)
            SceneManager.managerQueue.async(flags: .barrier) {
                SceneManager.managers.setObject(self, forKey: frame)
            }
        }
    }
    
    /**
     Sceneに紐づくDirectorとArgumentオブジェクト等を取得します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    internal func getStuff(frame: BaseScene) -> AnyObject? {
        var object: AnyObject?
        sceneQueue.sync {
            object = sceneHashMap.object(forKey: frame)
        }
        return object
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    static internal func managerByScene<S: Scene>(scene: S) -> SceneManager? {
        var manager: SceneManager?
        managerQueue.sync {
            manager = SceneManager.managers.object(forKey: scene)
        }
        
        return manager
    }
    
    /**
     このライブラリ外からinstance化させないため、コンストラクタをinternal化

     */
    internal init (){
        self.scenes = [BaseScene]()
        self.sceneQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    }
}
