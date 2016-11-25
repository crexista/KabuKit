//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scene : Frame {
    
    associatedtype linkType: Link
    
    associatedtype contextType
    
    associatedtype stageType
    
    var context: contextType? { get }
    
    unowned var transition: SceneTransition<linkType> { get }

    func onSceneTransitionRequest(container: stageType, link: linkType, maker: Maker, scenario: Scenario?) -> Frame?
    
    func onBackRequest(container: stageType)
}

extension Frame where Self: Scene {

    public func setup(stage: AnyObject, container: FrameContainer, scenario: Scenario?) {
        set(transition: SceneTransition<linkType>(stage, container, scenario))
    }
    
    public func back(stage: AnyObject) {
        onBackRequest(container: stage as! stageType)
    }


    public func transit<T: Link>(link: T, maker: Maker) -> Frame? {

        return onSceneTransitionRequest(container: maker.stage as! stageType,
                                   link: link as! linkType,
                                   maker: maker,
                                   scenario: maker.scenario)
    }
    
}

extension Scene {
    
    public unowned var transition: SceneTransition<linkType> {
        print(FrameStore.transitions)
        return FrameStore.transitions.object(forKey: self as AnyObject) as! SceneTransition<linkType>
    }
    
    public var context: contextType? {
        return FrameStore.contexts.object(forKey: self as AnyObject) as? contextType
    }

}
