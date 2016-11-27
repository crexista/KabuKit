//
//  SceneRequestFactory.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class SceneRequestFactory<Stage: AnyObject> {
    
    internal unowned let frames: FrameContainer
    internal unowned let stage: Stage
    internal weak var scenario: Scenario?
    
    public func create<T: SceneGenerator, S: Scene>(_ generator: T,
                                                    _ sceneType: S.Type,
                                                    _ context: S.Context?,
                                                    _ setup: @escaping (_ stage: Stage, _ scene: S) -> Void) -> SceneRequest where S.Stage == Stage {
        
        return SceneRequestImpl(generator: generator,
                                stage: stage,
                                sceneType: sceneType,
                                frames: frames,
                                scenario: scenario,
                                context: context,
                                f: setup)
    }
    
    deinit {
        print("SceneRequestFactory deinit")
    }
    
    init(_ stage: Stage, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}
