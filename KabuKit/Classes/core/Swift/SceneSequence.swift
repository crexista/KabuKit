//
//  Sequence.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import UIKit

/**
 This Class `SceneSequence` make new `Scene` and manage `Scene` instance on `SceneSequence`
 
 */
public class SceneSequence<T: AnyObject> {
    
    internal var manager: SceneManager
    
    internal unowned var stage: T // Scene.stageType
    
    internal weak var scenario: Scenario?

    /**
     This Mehtod generate `Scene` by sceneType and generator, and start `SceneSequence`
     
     - Parameter generator: Generator is logic that is required to generate `Scene` instance.
     - Parameter sceneType: SceneType is `Scene`'s Class
     - Parameter argument: Context is parameter that is required to invoke `Scene`.
     - Parameter setup: This is function. This function will be executed when `Scene` is generated
     */
    public func start<S: Scene, G: SceneGenerator>(_ generator: G,
                                                   _ sceneType: S.Type,
                                                   _ argument: S.ArgumentType? = nil,
                                                   _ setup: (T, S) -> Void) where T == S.TransitionType.StageType {
        
        let sceneClass = sceneType as! G.implType.Type
        let scene = generator.generater(impl: sceneClass, argument: generator.argument) as! S
        scene.setup(sequence: self, stage: stage, argument: argument, manager: manager, scenario: scenario)
        setup(stage, scene)
    }

    public init(_ container: T) {
        self.stage = container
        manager = SceneManager()
    }

    public init(_ container: T, _ scenario: Scenario?) {
        self.scenario = scenario
        self.stage = container
        manager = SceneManager()
    }
}
