//
//  Copyright © 2017 crexista
//

import Foundation

protocol ActionScene2 : Scene2 {
    var observer: SceneObserver2<RouterType>? { get }
}

extension ActionScene2 {
    var director: Director<RouterType>? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType>, ArgumentType?, SceneObserver2<RouterType>))?.0
    }
    
    var argument: ArgumentType? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType>, ArgumentType?, SceneObserver2<RouterType>))?.1
    }
    
    var observer: SceneObserver2<RouterType>? {
        let manager = SceneManager2.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType>, ArgumentType?, SceneObserver2<RouterType>))?.2
    }

    
    internal func setup(sequence: SceneSequence2<Self.RouterType.DestinationType.StageType>, arguments: ArgumentType?) {
        let director = Director(scene: self, sequence: sequence)
        let observer = SceneObserver2(director: director)
        sequence.manager.set(scene: self, stuff: (director, arguments, observer) as AnyObject)
    }

}
