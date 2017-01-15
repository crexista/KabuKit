//
//  Copyright © 2017 crexista
//

import Foundation

public protocol SceneBase {
    
    func setup(sequenceObject: Any, contextObject: Any?)
    
    func dispose()
}

public protocol Scene: class, SceneBase {
    
    associatedtype RouterType: SceneRouter
    
    associatedtype ContextType
    
    var router: RouterType { get }
    
    var director: Director<RouterType.DestinationType>? { get }
    
    var context: ContextType? { get }
    
    /**
     このSceneを管理しているSequenceから外される際に呼ばれるメソッドです.
     
     - attention: 
     管理をはずしメモリを解放するだけなので、このメソッドが呼ばれからと言って表示されなくなるわけではありません.
     このメソッド内でSceneを表示しているStageから外れるための処理を書いてください

     
     */
    func willRemove(from stage: RouterType.DestinationType.StageType)
    
}



/**
 Sceneの内部exetension
 単純にSceneをnewしてinitしただけではdirectorやcontextはnilなので
 生成されたSceneをセットアップするためのカテゴリ拡張です
 
 */
extension Scene {
    
    public var director: Director<RouterType.DestinationType>? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ContextType?))?.0
    }
    
    public var context: ContextType? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ContextType?))?.1
    }
    
}

extension SceneBase where Self: Scene {
    
    typealias DestType = RouterType.DestinationType
    typealias StageType = DestType.StageType
    
    public func setup(sequenceObject: Any, contextObject: Any?) {
        let sequence = sequenceObject as! SceneSequence<StageType>
        let director = Director(scene: self, sequence: sequence)
        let context = contextObject as! ContextType?
        sequence.manager.set(scene: self, stuff: (director, context) as AnyObject)
    }
    
    public func dispose() {
        let manager = SceneManager.managerByScene(scene: self)
        manager?.release(scene: self)
    }

}

public protocol SceneRouter {
    
    associatedtype DestinationType: Destination
    
    func connect<S: Scene>(from scene: S, to destination: DestinationType) -> SceneTransition<DestinationType.StageType>?
}

public protocol SceneLinkage : SceneRouter {
    
    func guide(to destination: DestinationType) -> SceneTransition<DestinationType.StageType>?
}

public extension SceneLinkage where Self: Scene, Self == Self.RouterType {
    
    var router: RouterType {
        return self
    }
    
    final func connect<S: Scene>(from scene: S, to destination: DestinationType) -> SceneTransition<DestinationType.StageType>? {
        return guide(to: destination)
    }
    
}


public protocol Destination {
    associatedtype StageType: AnyObject
    
    func specify<S: Scene>(_ newScene: S,
                           _ context: S.ContextType?,
                           _ atLast: @escaping (StageType, S) -> Void) -> SceneTransition<StageType>? where StageType == S.RouterType.DestinationType.StageType
    
}

public extension Destination {
    
    final func specify<S: Scene>(_ newScene: S,
                                 _ context: S.ContextType?,
                                 _ atLast: @escaping (StageType, S) -> Void) -> SceneTransition<StageType>? where StageType == S.RouterType.DestinationType.StageType {
        return SceneTransition(newScene, context, atLast)
    }
}
