//
//  Copyright © 2016 crexista.
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
     SceneGeneratorからSceneを生成し、Sceneのsetupを行います
     そしてその後にonSetupAfterに指定されたメソッドを呼び出します。
     
     */
    public func start<G: SceneGenerator>(_ generator: G,
                                          _ argument: G.SceneType.ArgumentType? = nil,
                                          _ onSetupAfter: (T, G.SceneType) -> Void) where T == G.SceneType.TransitionType.StageType {

        guard let scene = generator.generate() else {
            assert(false, "fail to make scene")
        }

        scene.setup(sequence: self, stage: stage, argument: argument, manager: manager, scenario: scenario)
        onSetupAfter(stage, scene)
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
