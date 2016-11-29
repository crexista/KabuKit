//
//  ActionScene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol ActionScene : Scene {
    unowned var actor: Actor { get }
}

extension ActionScene {
    
    public unowned var transition: SceneTransition<LinkType> {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneTransition<LinkType>, ContextType?, Actor)
        return result.0
    }
    
    public var context: ContextType? {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneTransition<LinkType>, ContextType?, Actor)
        return result.1
    }
    
    public unowned var actor: Actor {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneTransition<LinkType>, ContextType?, Actor)
        return result.2
    }
}

extension Frame where Self: ActionScene {
        
    public func setup<S: AnyObject, C>(stage: S, context: C, container: FrameManager, scenario: Scenario?) {
        let transition = SceneTransition<Self.LinkType>(stage, self, container, scenario)
        container.set(frame: self, stuff: (transition, context, Actor()) as AnyObject)
    }

}
