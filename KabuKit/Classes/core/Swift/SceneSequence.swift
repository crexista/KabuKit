//
//  Sequence.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import UIKit

/**
 This Class `SceneSequence` make new `Scene` and manage `Scene` instance on `SceneSequence`
 
 */
public class SceneSequence<T: AnyObject> {
    
    internal var frames: FrameContainer
    
    internal unowned var container: T // Scene.stageType
    
    internal weak var scenario: Scenario?

    /**
     This Mehtod generate `Scene` by sceneType and generator, and start `SceneSequence`
     
     - Parameter generator: Generator is logic that is required to generate `Scene` instance.
     - Parameter sceneType: SceneType is `Scene`'s Class
     - Parameter context: Context is parameter that is required to invoke `Scene`.
     - Parameter setup: This is function. This function will be executed when `Scene` is generated
     */
    public func start<S: Scene, G: SceneGenerator>(_ generator: G,
                                                   _ sceneType: S.Type,
                                                   _ context: S.Context? = nil,
                                                   _ setup: (T, S) -> Void) where T == S.Stage {
        
        let sceneClass = sceneType as! G.implType.Type
        let scene = generator.generater(impl: sceneClass, argument: generator.argument) as! S
        frames.frames.append(scene)
        scene.setup(stage: container, container: frames, scenario: scenario)
        scene.set(context: context)
        setup(container, scene)
    }

    public init(_ container: T) {
        self.container = container
        frames = FrameContainer()
    }

    public init(_ container: T, _ scenario: Scenario?) {
        self.scenario = scenario
        self.container = container
        frames = FrameContainer()
    }
}
