//
//  SceneRequestFactory.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneRequestFactory<StageType: AnyObject> {
    
    internal unowned let frames: FrameContainer
    internal unowned let stage: StageType
    internal weak var scenario: Scenario?
    
    public func createSceneRequest<T: SceneGenerator, S: Scene>(_ generator: T,
                                                                _ sceneType: S.Type,
                                                                _ context: S.ContextType?,
                                                                _ setup: @escaping (_ stage: StageType, _ scene: S) -> Void) -> SceneRequest where S.StageType == StageType {
        
        return SceneRequestImpl(generator: generator,
                                stage: stage,
                                sceneType: sceneType,
                                frames: frames,
                                scenario: scenario,
                                context: context,
                                f: setup)
    }
    
    
    public func createOtherScenarioRequest(_ setup: @escaping (_ stage: StageType, _ scene: Scenario?) -> Void) -> SceneRequest {
        return ScenarioRequestImpl(stage: stage, scenario: scenario, f: setup)
    }
    
    deinit {
        print("SceneRequestFactory deinit")
    }
    
    init(_ stage: StageType, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}

public class SceneBackRequestFactory<StageType: AnyObject> {
    
    private let stage: StageType
    
    public func createBackRequest(_ setup: @escaping (StageType) -> Bool) -> SceneBackRequest {
        return SceneBackRequestImpl<StageType>(stage: stage, f: setup)
    }
    
    init(stage: StageType) {
        self.stage = stage
    }
}
