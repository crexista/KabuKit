//
//  SceneTransition.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

/**
 This class supply transition that current scene to next scene, or back to previous scene.
 
 */
public class SceneTransition<linkType: Link> {
        
    private let stage: AnyObject
    
    private let frames: FrameContainer
    
    private weak var scenario: Scenario?
    
    /**
     transit to next scene
     
     */
    public func transitTo(link: linkType) {
        let currentFrame = frames.frames.last
        let frame = currentFrame?.transit(link: link, maker: Maker(stage, frames, scenario))
        if let newFrame = frame {
            frames.frames.append(newFrame)
        }
    }
    
    /**
     transit to previous scene, and try to destruct previous scene
     
     */
    public func back() {
        if let target = frames.frames.popLast() {
            target.back(stage: stage)
            target.close()
        }
    }
    
    deinit {
        print("transition deinit")
    }
    
    init(_ stage: AnyObject, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}
