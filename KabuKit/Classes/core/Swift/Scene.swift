//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scene : Frame {
    
    associatedtype Link: SceneLink
    
    associatedtype Context
    
    associatedtype Stage: AnyObject
    
    var context: Context? { get }
    
    unowned var transition: SceneTransition<Link> { get }
    
    func onChangeSceneRequest(link: Link, factory: SceneRequestFactory<Stage>) -> SceneRequest?
    
    func onBackRequest(container: Stage) -> Bool
}

extension Frame where Self: Scene {

    public func back(stage: Stage) -> Bool {
        return onBackRequest(container: stage)
    }

    public func back<S: AnyObject>(stage: S) -> Bool {
        return onBackRequest(container: stage as! Stage)
    }

    public func setup<S: AnyObject>(stage: S, container: FrameContainer, scenario: Scenario?) {
        let transition = SceneTransition<Self.Link>(stage, self, container, scenario)
        set(transition: transition)
    }
    
    public func transit(link: SceneLink, stage: AnyObject, frames: FrameContainer, scenario: Scenario?) -> SceneRequest? {
        let link2 = link as! Self.Link
        let stage2 = stage as! Self.Stage
        let sceneFactory = SceneRequestFactory<Self.Stage>(stage2, frames, scenario)
        return onChangeSceneRequest(link: link2, factory: sceneFactory)
    }

}

extension Scene {
    
    public unowned var transition: SceneTransition<Link> {
        return FrameStore.transitions.object(forKey: self as AnyObject) as! SceneTransition<Link>
    }
    
    public var context: Context? {
        return FrameStore.contexts.object(forKey: self as AnyObject) as? Context
    }

}
