//
//  SceneChangeRequest.swift
//  KabuKit
//
//  Created by crexista on 2016/11/28.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol SceneChangeRequest {
    
    func execute()    
}

struct SceneChangeRequestImpl<SceneType: Scene, GeneratorType: SceneGenerator> : SceneChangeRequest {
    
    private let method: (_ stage: SceneType.TransitionType.StageType, _ scene: SceneType) -> Void
    private let stage: SceneType.TransitionType.StageType
    private let sceneType: SceneType.Type
    private let context: SceneType.ContextType?
    private let generator: GeneratorType
    private let frames: FrameManager
    private let scenario: Scenario?
    
    func execute() {
        let sceneClass = sceneType as! GeneratorType.implType.Type
        let newScene = generator.generater(impl: sceneClass, argument: generator.argument) as? SceneType
        newScene?.setup(stage: stage, context: context, container: frames, scenario: scenario)
        if let scene = newScene {
            method(stage, scene)
        }

    }
    
    init(generator: GeneratorType,
         stage: SceneType.TransitionType.StageType,
         sceneType: SceneType.Type,
         frames: FrameManager,
         scenario: Scenario?,
         context: SceneType.ContextType?,
         f: @escaping (_ stage: SceneType.TransitionType.StageType, _ scene: SceneType) -> Void) {
        
        self.method = f
        self.stage = stage
        self.sceneType = sceneType
        self.generator = generator
        self.context = context
        self.frames = frames
        self.scenario = scenario
    }
    
}

struct ScenarioRequestImpl<StageType>: SceneChangeRequest {
    
    let method: (_ stage: StageType, _ scene: Scenario?) -> Void
    
    let scenario: Scenario?
    
    let stage: StageType
    
    func execute() {
        method(stage, scenario)
    }
    
    init(stage: StageType, scenario: Scenario?, f: @escaping (_ stage: StageType, _ scene: Scenario?) -> Void) {
        self.scenario = scenario
        self.stage = stage
        method = f
    }
}

