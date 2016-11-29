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
    private let sequence: AnyObject
    private let scenario: Scenario?
    
    func execute() {
        let sceneClass = sceneType as! GeneratorType.implType.Type
        let newScene = generator.generater(impl: sceneClass, argument: generator.argument) as? SceneType
        newScene?.setup(sequence: sequence, stage: stage, context: context, container: frames, scenario: scenario)
        if let scene = newScene {
            method(stage, scene)
        }

    }
    
    init(generator: GeneratorType,
         sequence: AnyObject,
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
        self.sequence = sequence
    }
    
}

struct ScenarioRequestImpl<StageType: AnyObject>: SceneChangeRequest {
//    typealias StageType = SceneType.TransitionType.StageType
    
    let method: () -> AnyObject
    
    let scenario: Scenario?
    
    let stage: StageType
    
    let sequnce: AnyObject
    
    let scene: Frame
    
    func execute() {
        if let sce = scenario {
            let seq = sequnce as! SceneSequence<StageType>
            let event = method()

            sce.onEvent(currentStage: stage, currentSequence: seq, currentScene: scene, event: event)
        }
    }
    
    init(sequence: AnyObject, scene: Frame, stage: StageType, scenario: Scenario?, f: @escaping () -> AnyObject) {
        self.scenario = scenario
        self.stage = stage
        self.sequnce = sequence
        self.scene = scene
        method = f
    }
}

