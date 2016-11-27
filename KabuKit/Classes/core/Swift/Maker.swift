//
//  Maker.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Request {
    
    func execute() -> Frame?

}

public class Maker<Stage: AnyObject> {
    
    internal unowned let frames: FrameContainer
    internal unowned let stage: Stage
    internal weak var scenario: Scenario?
    
    public func make<T: SceneGenerator, S: Scene>(_ generator: T,
                                                  _ sceneType: S.Type,
                                                  _ context: S.Context?,
                                                  _ setup: @escaping (_ stage: Stage, _ scene: S) -> Void) -> Request where S.Stage == Stage {
        
        return SceneRequest(generator: generator,
                            stage: stage,
                            sceneType: sceneType,
                            frames: frames,
                            scenario: scenario,
                            context: context,
                            f: setup)
    }
    
    deinit {
        print("maker deinit")
    }
    
    init(_ stage: Stage, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}

public struct SceneRequest<StageType, SceneType: Scene, GeneratorType: SceneGenerator> : Request {
    
    private let method: (_ stage: StageType, _ scene: SceneType) -> Void
    private let stage: StageType
    private let sceneType: SceneType.Type
    private let context: SceneType.Context?
    private let generator: GeneratorType
    private let frames: FrameContainer
    private let scenario: Scenario?
    
    public func execute() -> Frame? {
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
