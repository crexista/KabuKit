//
//  SceneDirector.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © crexista. All rights reserved.
//

import Foundation

/**
 This class supply director that current scene to next scene, or back to previous scene.
 
 */
public class SceneDirector<TransitionType: SceneTransition> {
    
    private unowned let stage: TransitionType.StageType
    
    private unowned let manager: SceneManager
    
    private unowned let sequence: AnyObject
    
    private weak var currentScene: SceneBase?
    
    private weak var scenario: Scenario?
    
    /**
     transit to next scene
     
     */
    public func changeScene(transition: TransitionType) {
        let factory = SceneContext(sequence, currentScene!, stage, manager, scenario)
        transition.request(context: factory)?.execute()
    }
    
    /**
     transit to previous scene, and try to destruct previous scene
     
     */
    public func exitScene() {
        if let frame = currentScene {
            frame.clear(stage: stage, manager: manager)
        }
    }
    
    deinit {
        print("director deinit")
    }
    
    init(_ sequence: AnyObject, _ stage: TransitionType.StageType, _ scene: SceneBase, _ manager: SceneManager, _ scenario: Scenario?) {
        self.stage = stage
        self.manager = manager
        self.scenario = scenario
        self.currentScene = scene
        self.sequence = sequence
    }
    
}
