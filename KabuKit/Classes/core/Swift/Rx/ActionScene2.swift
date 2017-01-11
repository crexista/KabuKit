//
//  Copyright © 2017 crexista
//

import Foundation

public protocol ActionScene2 : Scene2 {
    var observer: SceneObserver2<RouterType.DestinationType>? { get }
}

extension ActionScene2 {
    public var director: Director<RouterType.DestinationType>? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver2<RouterType.DestinationType>))?.0
    }
    
    public var argument: ArgumentType? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver2<RouterType.DestinationType>))?.1
    }
    
    public var observer: SceneObserver2<RouterType.DestinationType>? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ArgumentType?, SceneObserver2<RouterType.DestinationType>))?.2
    }

    
    internal func setup(sequence: SceneSequence2<Self.RouterType.DestinationType.StageType>, arguments: ArgumentType?) {
        let director = Director(scene: self, sequence: sequence)
        let observer = SceneObserver2(director: director)
        sequence.manager.set(scene: self, stuff: (director, arguments, observer) as AnyObject)
    }

}
