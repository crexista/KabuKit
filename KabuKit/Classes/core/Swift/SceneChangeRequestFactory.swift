//
//  SceneChangeRequestFactory.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneChangeRequestFactory<StageType: AnyObject> {
    
    internal unowned let frames: FrameManager
    internal unowned let stage: StageType
    internal weak var scenario: Scenario?
    
    public func createSceneChangeRequest<T: SceneGenerator, S: Scene>(_ generator: T,
                                                                _ sceneType: S.Type,
                                                                _ context: S.ContextType?,
                                                                _ setup: @escaping (_ stage: StageType, _ scene: S) -> Void) -> SceneChangeRequest where S.StageType == StageType {
        
        return SceneChangeRequestImpl(generator: generator,
                                stage: stage,
                                sceneType: sceneType,
                                frames: frames,
                                scenario: scenario,
                                context: context,
                                f: setup)
    }
    
    
    public func createOtherScenarioRequest(_ setup: @escaping (_ stage: StageType, _ scene: Scenario?) -> Void) -> SceneChangeRequest {
        return ScenarioRequestImpl(stage: stage, scenario: scenario, f: setup)
    }
    
    deinit {
        print("SceneChangeRequestFactory deinit")
    }
    
    init(_ stage: StageType, _ container: FrameManager, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}
