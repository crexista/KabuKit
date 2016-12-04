//
//  ActionScene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol ActionScene : Scene {
    unowned var actor: Actor { get }
}

extension ActionScene {
    
    public weak var director: SceneDirector<TransitionType>? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(frame: self) as? (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor) else {
            assert(false, "Illegal Operation Error")
        }
        return sceneContents.0
    }
    
    public var argument: ArgumentType? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(frame: self) as? (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor) else {
            assert(false, "Illegal Operation Error")
        }
        return sceneContents.1
    }
    
    public unowned var actor: Actor {
        guard let sceneContents = SceneManager.managerByScene(scene: self)?.getStuff(frame: self) as? (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor) else {
            assert(false, "Illegal Operation Error")
        }
        return sceneContents.2
    }
}

extension SceneBase where Self: ActionScene {
    public func setup<S, C>(sequence:AnyObject, stage: S, argument: C, container: SceneManager, scenario: Scenario?) {
        let director = DefaultSceneDirector<TransitionType>(sequence, stage as! TransitionType.StageType, self, container, scenario)
        container.set(frame: self, stuff: (director, argument, Actor()) as AnyObject)
    }

}
