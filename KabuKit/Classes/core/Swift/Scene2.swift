//
//  Copyright © 2017年 crexista
//

import Foundation

public protocol Scene2: class {
    
    associatedtype RouterType: SceneRouter
    
    associatedtype ArgumentType
    
    var router: RouterType { get }
    
    var director: Director<RouterType.DestinationType>? { get }
    
    var argument: ArgumentType? { get }
    
    /**
     画面上で行なわれている処理がひと段落し、
     画面自体をremoveしても良いかどうかを返します.
     
     このプロパティがfalseを返した場合、下記のonRemoveは呼ばれません.
     */
    var isRemovable: Bool { get }
    
    /**
     Sceneが削除されるときに呼ばれます.
     画面上から消すための処理をここに記述してください
     
     */
    func onRemove(stage: RouterType.DestinationType.StageType)
    
}

/**
 Sceneの内部exetension
 単純にSceneをnewしてinitしただけではdirectorやargumentはnilなので
 生成されたSceneをセットアップするためのカテゴリ拡張です
 
 */
extension Scene2 {
    
    public var director: Director<RouterType.DestinationType>? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?))?.0
    }
    
    public var argument: ArgumentType? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?))?.1
    }
    
    func setup(sequence: SceneSequence2<Self.RouterType.DestinationType.StageType>, arguments: ArgumentType?) {
        let director = Director(scene: self, sequence: sequence)        
        sequence.manager.set(scene: self, stuff: (director, arguments) as AnyObject)
    }
    
}

public protocol SceneRouter {
    
    associatedtype DestinationType: Destination
    
    func handle<S: Scene2>(scene: S, request: DestinationType) -> Transition<DestinationType.StageType>?
}

public protocol SceneLinkage : SceneRouter {
    
    func onMove(destination: DestinationType) -> Transition<DestinationType.StageType>?
}

public extension SceneLinkage where Self: Scene2, Self == Self.RouterType {
    
    var router: RouterType {
        return self
    }
    
    final func handle<S: Scene2>(scene: S, request: DestinationType) -> Transition<DestinationType.StageType>? {
        return onMove(destination: request)
    }
    
}


public protocol Destination {
    associatedtype StageType: AnyObject
    
    func makeTransition<S: Scene2>(_ newScene: S,
                                   _ argument: S.ArgumentType?,
                                   _ onTransition: @escaping (StageType, S) -> Void) -> Transition<StageType>? where StageType == S.RouterType.DestinationType.StageType
    
}

public extension Destination {
    
    
    final func makeTransition<S: Scene2>(_ newScene: S,
                                         _ argument: S.ArgumentType?,
                                         _ onTransition: @escaping (StageType, S) -> Void) -> Transition<StageType>? where StageType == S.RouterType.DestinationType.StageType {
        return Transition(newScene, argument, onTransition)
    }
}
