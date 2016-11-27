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
public class SceneTransition<Link: SceneLink> {
    
    private unowned let stage: AnyObject
    
    private unowned let frames: FrameContainer
    
    private weak var currentFrame: Frame?
    
    private weak var scenario: Scenario?
    
    /**
     transit to next scene
     
     */
    public func transitTo(link: Link) {
        let frame = currentFrame?.transit(link: link, stage: stage, frames: frames, scenario: scenario)?.execute()
        if let newFrame = frame {
            frames.frames.append(newFrame)
        }
    }
    
    /**
     transit to previous scene, and try to destruct previous scene
     
     */
    public func back() {
        currentFrame.map { (frame) -> Void in
            if (frame.back(stage: stage)) {
                frame.close()
                _ = frames.frames.popLast()
            }
        }

    }
    
    deinit {
        print("transition deinit")
    }
    
    init(_ stage: AnyObject, _ frame: Frame, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
        self.currentFrame = frame
    }
    
}
