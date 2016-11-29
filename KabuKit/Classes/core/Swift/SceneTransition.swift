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
    
    private unowned let frames: FrameManager
    
    private weak var currentFrame: Frame?
    
    private weak var scenario: Scenario?
    
    /**
     transit to next scene
     
     */
    public func transitTo(link: Link) {
        _ = currentFrame?.transit(link: link, stage: stage, frames: frames, scenario: scenario)?.execute()
    }
    
    /**
     transit to previous scene, and try to destruct previous scene
     
     */
    public func back() {
        currentFrame.map { (frame) -> Void in
            if (frame.back(stage: stage)?.execute())! {
                frames.release(frame: frame)
            }
        }

    }
    
    deinit {
        print("transition deinit")
    }
    
    init(_ stage: AnyObject, _ frame: Frame, _ container: FrameManager, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
        self.currentFrame = frame
    }
    
}
