//
//  Copyright © 2017 crexista
//

import Foundation

public protocol ActionScene : Scene {
    var observer: SceneObserver<RouterType.DestinationType>? { get }
}

extension ActionScene where Self: Scene {
    public var director: Director<RouterType.DestinationType>? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver<RouterType.DestinationType>))?.0
    }
    
    public var argument: ArgumentType? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver<RouterType.DestinationType>))?.1
    }
    
    public var observer: SceneObserver<RouterType.DestinationType>? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver<RouterType.DestinationType>))?.2
    }

}


public extension SceneBase where Self: ActionScene {
    
    public func setup(sequenceObject: Any, argumentObject: Any?) {
        let sequence = sequenceObject as! SceneSequence<StageType>
        let director = Director(scene: self, sequence: sequence)
        let argument = argumentObject as! ArgumentType?
        let observer = SceneObserver(director: director)
        sequence.manager.set(scene: self, stuff: (director, argument, observer) as AnyObject)
    }
    
}
