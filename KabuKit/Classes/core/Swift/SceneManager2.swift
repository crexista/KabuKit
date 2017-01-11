//
//  Copyright © 2017 crexista.
//

import Foundation

/**
 SceneのLifeCycleの管理をします。
 現在有効(表示されている)Sceneを返したり、
 不必要となってどこからも参照がされなくなったSceneのメモリ解放を行ったりします
 
 */
final public class SceneManager2 : Hashable, Equatable {
    
    // key: Scene
    private static let managers: NSMapTable<AnyObject, SceneManager2> = NSMapTable.weakToWeakObjects()
    
    private static let managerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    
    // key: Scene, value: (director, argument) のタプルか (director, argument, actor) のタプル
    private var sceneHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    // Sceneをスタックし、現在有効なSceneを取り出せるようにします
    internal var scenes: [AnyObject]
    
    // frameHashMap, scens その両方を操作する際に必要となるdispatch queue
    private let sceneQueue: DispatchQueue
    
    public let hashValue: Int
    
    internal var count: Int {
        return sceneQueue.sync {
            return scenes.count
        }
    }
    
    /**
     現在有効(ユーザに表示しているであろう)Sceneを返します
     ## 注意 ##
     内部的にsyncをしているため呼びだす際にsyncを使う必要はありません
     
     */
    internal func currentScene<S: Scene2>() -> S? {
        return sceneQueue.sync {
            return self.scenes.last as? S
        }
    }
    
    internal func isCurrentScene<S: Scene2>(scene: S) -> Bool {
        return sceneQueue.sync {
            return (self.scenes.last === scene)
        }
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func release<S: Scene2>(scene: S) {
        sceneQueue.sync {
            SceneManager2.managerQueue.sync {
                SceneManager2.managers.removeObject(forKey: scene)
            }
            _ = self.scenes.popLast()
            self.sceneHashMap.removeObject(forKey: scene)
        }
    }
    
    internal func pop() {
        sceneQueue.sync {
            let scene = self.scenes.popLast()
            SceneManager2.managerQueue.sync {
                SceneManager2.managers.removeObject(forKey: scene)
            }

            self.sceneHashMap.removeObject(forKey: scene)
        }
    }
    
    /**
     SceneManagerで管理されているSceneを全て解放します
     
     */
    internal func dispose() {
        sceneQueue.sync {
            self.scenes.removeAll()
            self.sceneHashMap.removeAllObjects()
            
            // SceneManagerはstaticであり違うスレッドからリクエストされる可能性があるため2重ロックにしてます
            SceneManager2.managerQueue.sync {
                self.scenes.forEach{ (scene) in
                    SceneManager2.managers.removeObject(forKey: scene)
                }
            }
        }
    }
    
    /**
     Sceneをキーとして、それに紐づくDirectorとArgumentオブジェクトを紐付けます
     
     ## 注意 ##
     内部的には非同期のbarrier queue で行われています
     
     */
    internal func set<S: Scene2>(scene: S, stuff: AnyObject) {
        sceneQueue.sync {
            self.sceneHashMap.setObject(stuff, forKey: scene)
            self.scenes.append(scene)
            SceneManager2.managerQueue.sync(flags: .barrier) {
                SceneManager2.managers.setObject(self, forKey: scene)
            }
        }
    }
    
    /**
     Sceneに紐づくDirectorとArgumentオブジェクト等を取得します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    internal func getStuff<S: Scene2>(scene: S) -> AnyObject? {
        return sceneQueue.sync {
            return sceneHashMap.object(forKey: scene)
        }
    }
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     ## 注意 ##
     同期Queuedで実行されているため呼びだす側でsyncをかける必要はありません
     
     */
    static internal func managerByScene<S: Scene2>(scene: S) -> SceneManager2? {
        return managerQueue.sync {
            return SceneManager2.managers.object(forKey: scene)
        }
    }
    
    /**
     全てのSceneManagerからSceneを解放します
     
     */
    static internal func removeAll() {
        SceneManager2.managerQueue.sync {
            let enumerator = SceneManager2.managers.keyEnumerator()
            while let key = enumerator.nextObject() {
                let manager = SceneManager2.managers.object(forKey: key as AnyObject?)
                manager?.dispose()
            }
            SceneManager2.managers.removeAllObjects()
        }
    }
    
    public static func == (lhs: SceneManager2, rhs: SceneManager2) -> Bool {
        
        return lhs.hashValue == rhs.hashValue
    }
    
    /**
     このライブラリ外からinstance化させないため、コンストラクタをinternal化
     
     */
    internal init (){
        self.scenes = [AnyObject]()
        self.sceneQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        self.hashValue = UUID().uuidString.hashValue
    }
}
