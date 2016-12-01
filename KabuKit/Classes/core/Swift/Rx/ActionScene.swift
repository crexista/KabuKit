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
        let manager = SceneManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor)
        return result.0
    }
    
    public var argument: ArgumentType? {
        let manager = SceneManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor)
        return result.1
    }
    
    public unowned var actor: Actor {
        let manager = SceneManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (DefaultSceneDirector<TransitionType>, ArgumentType?, Actor)
        return result.2
    }
}

extension BaseScene where Self: ActionScene {
    public func setup<S, C>(sequence:AnyObject, stage: S, argument: C, container: SceneManager, scenario: Scenario?) {
        let director = DefaultSceneDirector<TransitionType>(sequence, stage as! TransitionType.StageType, self, container, scenario)
        container.set(frame: self, stuff: (director, argument, Actor()) as AnyObject)
    }

}
