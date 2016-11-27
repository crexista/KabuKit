//
//  SceneRequest.swift
//  KabuKit
//
//  Created by crexista on 2016/11/28.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol SceneRequest {
    
    func execute() -> Frame?
    
}

struct SceneRequestImpl<StageType, SceneType: Scene, GeneratorType: SceneGenerator> : SceneRequest {
    
    private let method: (_ stage: StageType, _ scene: SceneType) -> Void
    private let stage: StageType
    private let sceneType: SceneType.Type
    private let context: SceneType.Context?
    private let generator: GeneratorType
    private let frames: FrameContainer
    private let scenario: Scenario?
    
    func execute() -> Frame? {
        let sceneClass = sceneType as! GeneratorType.implType.Type
        let newScene = generator.generater(impl: sceneClass, argument: generator.argument) as? SceneType
        newScene?.setup(stage: stage as! SceneType.Stage, container: frames, scenario: scenario)
        newScene?.set(context: context)
        if let scene = newScene {
            method(stage, scene)
        }
        return newScene
    }
    
    init(generator: GeneratorType,
         stage: StageType,
         sceneType: SceneType.Type,
         frames: FrameContainer,
         scenario: Scenario?,
         context: SceneType.Context?,
         f: @escaping (_ stage: StageType, _ scene: SceneType) -> Void) {
        
        self.method = f
        self.stage = stage
        self.sceneType = sceneType
        self.generator = generator
        self.context = context
        self.frames = frames
        self.scenario = scenario
    }
    
}

struct ScenarioRequestImpl<StageType>: SceneRequest {
    
    let method: (_ stage: StageType, _ scene: Scenario?) -> Void
    
    let scenario: Scenario?
    
    let stage: StageType
    
    func execute() -> Frame? {
        method(stage, scenario)
        return nil
    }
    
    init(stage: StageType, scenario: Scenario?, f: @escaping (_ stage: StageType, _ scene: Scenario?) -> Void) {
        self.scenario = scenario
        self.stage = stage
        method = f
    }
}
