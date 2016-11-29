//
//  SceneContext.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneContext<StageType: AnyObject> {
    
    internal unowned let frames: FrameManager
    internal unowned let stage: StageType
    internal unowned let sequence: AnyObject
    internal unowned let scene: Frame
    
    internal weak var scenario: Scenario?
    
    public func sceneRequest<T: SceneGenerator, S: Scene>(_ generator: T,
                                                          _ sceneType: S.Type,
                                                          _ argument: S.ArgumentType?,
                                                          _ setup: @escaping (_ stage: StageType, _ scene: S) -> Void) -> SceneChangeRequest where T.implType == S.TransitionType.StageType, StageType == S.TransitionType.StageType {

        return SceneChangeRequestImpl(generator: generator,
                                      sequence: sequence,
                                      stage: stage,
                                      sceneType: sceneType,
                                      frames: frames,
                                      scenario: scenario,
                                      argument: argument,
                                      f: setup)
    }
    

    public func sequenceRequest(_ setup: @escaping () -> AnyObject) -> SceneChangeRequest {
        return ScenarioRequestImpl(sequence: sequence, scene: scene, stage: stage, scenario: scenario, f: setup)
    }

    deinit {
        print("SceneContext deinit")
    }
    
    init(_ sequence: AnyObject, _ scene: Frame, _ stage: StageType, _ container: FrameManager, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
        self.sequence = sequence
        self.scene = scene
    }
    
}
