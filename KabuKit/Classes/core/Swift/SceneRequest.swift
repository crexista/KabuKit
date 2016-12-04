//
//  SceneRequest.swift
//  KabuKit
//
//  Created by crexista on 2016/11/28.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol SceneRequest {
    
    func execute()    
}

struct SceneRequestImpl<SceneType: Scene, GeneratorType: SceneGenerator> : SceneRequest {
    
    private let method: (_ stage: SceneType.TransitionType.StageType, _ scene: SceneType) -> Void
    private let stage: SceneType.TransitionType.StageType
    private let sceneType: SceneType.Type
    private let argument: SceneType.ArgumentType?
    private let generator: GeneratorType
    private let manager: SceneManager
    private let sequence: AnyObject
    private let scenario: Scenario?
    
    func execute() {
        let sceneClass = sceneType as! GeneratorType.implType.Type
        let newScene = generator.generater(impl: sceneClass, argument: generator.argument) as? SceneType
        newScene?.setup(guard: SceneBaseGuard.sharedInstance,sequence: sequence, stage: stage, argument: argument, manager: manager, scenario: scenario)
        if let scene = newScene {
            method(stage, scene)
        }

    }
    
    init(generator: GeneratorType,
         sequence: AnyObject,
         stage: SceneType.TransitionType.StageType,
         sceneType: SceneType.Type,
         manager: SceneManager,
         scenario: Scenario?,
         argument: SceneType.ArgumentType?,
         f: @escaping (_ stage: SceneType.TransitionType.StageType, _ scene: SceneType) -> Void) {
        
        self.method = f
        self.stage = stage
        self.sceneType = sceneType
        self.generator = generator
        self.argument = argument
        self.manager = manager
        self.scenario = scenario
        self.sequence = sequence
    }
    
}

struct ScenarioRequestImpl<StageType: AnyObject>: SceneRequest {
    
    let method: () -> AnyObject
    
    let scenario: Scenario?
    
    let stage: StageType
    
    let sequnce: AnyObject
    
    let scene: SceneBase
    
    func execute() {
        if let sce = scenario {
            let seq = sequnce as! SceneSequence<StageType>
            let event = method()

            sce.onEvent(currentStage: stage, currentSequence: seq, currentScene: scene, event: event)
        }
    }
    
    init(sequence: AnyObject, scene: SceneBase, stage: StageType, scenario: Scenario?, f: @escaping () -> AnyObject) {
        self.scenario = scenario
        self.stage = stage
        self.sequnce = sequence
        self.scene = scene
        method = f
    }
}

