//
//  SceneManager.swift
//  KabuKit
//
//  Created by crexista on 2016/12/04.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

/**
 SceneのLifeCycleの管理をします。
 現在有効(表示されている)Sceneを返したり、
 不必要となってどこからも参照がされなくなったSceneのメモリ解放を行ったりします
 
 */
final public class SceneManager : Hashable, Equatable {
    
    // key: Scene
    private static let managers: NSMapTable<AnyObject, SceneManager> = NSMapTable.weakToWeakObjects()
    
    private static let managerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    
    // key: Scene, value: (director, argument) のタプルか (director, argument, actor) のタプル
    private var sceneHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    // Sceneをスタックし、現在有効なSceneを取り出せるようにします
    private var scenes: [SceneBase]
    
    // frameHashMap, scens その両方を操作する際に必要となるdispatch queue
    private let sceneQueue: DispatchQueue
    
    public let hashValue: Int
    
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
    internal func release(scene: SceneBase) {
        sceneQueue.sync(flags: .barrier) {
            SceneManager.managerQueue.sync {
                SceneManager.managers.removeObject(forKey: scene)
            }
            _ = self.scenes.popLast()
            self.sceneHashMap.removeObject(forKey: scene)
        }
    }
    
    /**
     SceneManagerで管理されているSceneを全て解放します
     
     */
    internal func dispose() {
        sceneQueue.sync(flags: .barrier) {
            self.scenes.removeAll()
            self.sceneHashMap.removeAllObjects()
            
            // SceneManagerはstaticであり違うスレッドからリクエストされる可能性があるため2重ロックにしてます
            SceneManager.managerQueue.sync {
                self.scenes.forEach{ (scene) in
                    SceneManager.managers.removeObject(forKey: scene)
                }
            }
        }
    }
    
    /**
     Sceneをキーとして、それに紐づくDirectorとArgumentオブジェクトを紐付けます
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func set(scene: SceneBase, stuff: AnyObject) {
        sceneQueue.sync(flags: .barrier) {
            self.sceneHashMap.setObject(stuff, forKey: scene)
            self.scenes.append(scene)
            SceneManager.managerQueue.sync(flags: .barrier) {
                SceneManager.managers.setObject(self, forKey: scene)
            }
        }
    }
    
    /**
     Sceneに紐づくDirectorとArgumentオブジェクト等を取得します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    internal func getStuff(scene: SceneBase) -> AnyObject? {
        return sceneQueue.sync {
            return sceneHashMap.object(forKey: scene)
        }
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    static internal func managerByScene<S: Scene>(scene: S) -> SceneManager? {
        return managerQueue.sync {
            return SceneManager.managers.object(forKey: scene)
        }
    }
    
    /**
     全てのSceneManagerからSceneを解放します
     
     */
    static internal func removeAll() {
        SceneManager.managerQueue.sync(flags: .barrier) {
            let enumerator = SceneManager.managers.keyEnumerator()
            while let key = enumerator.nextObject() {
                let manager = SceneManager.managers.object(forKey: key as AnyObject?)
                manager?.dispose()
            }
            SceneManager.managers.removeAllObjects()
        }
    }
    
    public static func == (lhs: SceneManager, rhs: SceneManager) -> Bool {
        
        return lhs.hashValue == rhs.hashValue
    }
    
    /**
     このライブラリ外からinstance化させないため、コンストラクタをinternal化
     
     */
    internal init (){
        self.scenes = [SceneBase]()
        self.sceneQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        self.hashValue = UUID().uuidString.hashValue
    }
}
