//
//  Maker.swift
//  KabuKit
//
//  Created by crexista on 2016/11/21.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public class Maker {
    
    internal unowned let frames: FrameContainer
    
    internal unowned let stage: AnyObject
    
    internal weak var scenario: Scenario?
    
    public func make<T: SceneGenerator, S: Scene>(_ generator: T, _ sceneType: S.Type, _ context: S.contextType?) -> S {
        let sceneClass = sceneType as! T.implType.Type
        let newScene = generator.generater(impl: sceneClass, argument: generator.argument) as! S
        newScene.setup(stage: stage, container: frames, scenario: scenario)
        newScene.set(context: context)
        return newScene
    }
    
    deinit {
        print("maker deinit")
    }
    
    init(_ stage: AnyObject, _ container: FrameContainer, _ scenario: Scenario?) {
        self.stage = stage
        self.frames = container
        self.scenario = scenario
    }
    
}
