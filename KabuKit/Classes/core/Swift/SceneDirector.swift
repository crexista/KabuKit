//
//  SceneDirector.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

/**
 This class supply director that current scene to next scene, or back to previous scene.
 
 */
public class DefaultSceneDirector<TransitionType: SceneTransition> : SceneDirector<TransitionType> {
    
    private unowned let stage: TransitionType.StageType
    
    private unowned let frames: FrameManager
    
    private unowned let sequence: AnyObject
    
    private weak var currentFrame: Frame?
    
    private weak var scenario: Scenario?
    

    
    /**
     transit to next scene
     TODO 後でlinkの名前とtransitionに変更する
     
     */
    override public func transitTo(link: TransitionType) {
        let factory = SceneContext(sequence, currentFrame!, stage, frames, scenario)
        link.request(context: factory)?.execute()
    }
    
    /**
     transit to previous scene, and try to destruct previous scene
     
     */
    override public func exit() {
        if let frame = currentFrame {
            if (frame.clear(stage: stage)) {
                frames.release(frame: frame)
            }
        }
    }
    
    deinit {
        print("director deinit")
    }
    
    init(_ sequence: AnyObject, _ stage: TransitionType.StageType, _ frame: Frame, _ container: FrameManager, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
        self.currentFrame = frame
        self.sequence = sequence
    }
    
}

public class SceneDirector<TransitionType: SceneTransition> {
    
    public func transitTo(link: TransitionType) {}
    
    public func exit() {}
}
