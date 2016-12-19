//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol ActionScene : Scene {
    unowned var observer: SceneObserver { get }
}

extension ActionScene {
    
    public weak var director: SceneDirector<TransitionType>? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(scene: self) as? (SceneDirector<TransitionType>, ArgumentType?, SceneObserver) else {
            assert(false, "Illegal Operation Error")
            return nil
        }
        return sceneContents.0
    }
    
    public var argument: ArgumentType? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(scene: self) as? (SceneDirector<TransitionType>, ArgumentType?, SceneObserver) else {
            assert(false, "Illegal Operation Error")
            return nil
        }
        return sceneContents.1
    }
    
    public unowned var observer: SceneObserver {
        guard let sceneContents = SceneManager.managerByScene(scene: self)?.getStuff(scene: self) as? (SceneDirector<TransitionType>, ArgumentType?, SceneObserver) else {
            assert(false, "Illegal Operation Error")
            fatalError()
        }
        return sceneContents.2
    }
}

extension SceneBase where Self: ActionScene {
    
    public func setup<S, C>(sequence:AnyObject, stage: S, argument: C, manager: SceneManager, scenario: Scenario?) {
        let director = SceneDirector<TransitionType>(sequence, stage as! TransitionType.StageType, self, manager, scenario)
        manager.set(scene: self, stuff: (director, argument, SceneObserver()) as AnyObject)
    }

}
