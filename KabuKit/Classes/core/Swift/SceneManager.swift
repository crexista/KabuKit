//
//  SceneManager.swift
//  KabuKit
//
//  Created by crexista on 2016/12/04.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneManager {
    
    // key: Scene
    private static var managers: NSMapTable<AnyObject, SceneManager> = NSMapTable.weakToWeakObjects()
    
    private static let managerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    
    // key: Scene, value: (director, argument) のタプルか (director, argument, actor) のタプル
    private var sceneHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    // Sceneをスタックし、現在有効なSceneを取り出せるようにします
    private var scenes: [SceneBase]
    
    // frameHashMap, scens その両方を操作する際に必要となるdispatch queue
    private let sceneQueue: DispatchQueue
    
    /**
     現在有効(ユーザに表示しているであろう)Sceneを返します
     ## 注意 ##
     内部的にsyncをしているため呼びだす際にsyncを使う必要はありません
     
     */
    internal var currentScene: SceneBase? {
        return sceneQueue.sync {
            return self.scenes.last
        }
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func release(frame: SceneBase) {
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
    internal func set(frame: SceneBase, stuff: AnyObject) {
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
    internal func getStuff(frame: SceneBase) -> AnyObject? {
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
        self.scenes = [SceneBase]()
        self.sceneQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    }
}
