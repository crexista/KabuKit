//
//  Copyright © 2017 crexista
//

import Foundation

public protocol ActionScene : Scene {
    var activator: ActionActivator<RouterType.DestinationType>? { get }
}

extension ActionScene where Self: Scene {
    public var director: Director<RouterType.DestinationType>? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ContextType?, ActionActivator<RouterType.DestinationType>))?.0
    }
    
    public var context: ContextType? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ContextType?, ActionActivator<RouterType.DestinationType>))?.1
    }
    
    public var activator: ActionActivator<RouterType.DestinationType>? {
        let manager = SceneManager.managerByScene(scene: self)
        let data = manager?.getStuff(scene: self)
        return (data as? (Director<RouterType.DestinationType>, ContextType?, ActionActivator<RouterType.DestinationType>))?.2
    }

}


public extension SceneBase where Self: ActionScene {
    
    public func setup(sequenceObject: Any, contextObject: Any?) {
        let sequence = sequenceObject as! SceneSequence<StageType>
        let director = Director(scene: self, sequence: sequence)
        let context = contextObject as! ContextType?
        let activator = ActionActivator(director: director)
        sequence.manager.set(scene: self, stuff: (director, context, activator) as AnyObject)
    }
    
}
