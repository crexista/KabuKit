//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol SceneRequest {
    
    func execute()    
}

public struct SceneRequest2<SceneType: Scene> {
    
    private let method: (_ stage: SceneType.TransitionType.StageType, _ newScene: SceneType, _ prevScene: SceneBase) -> Void
    
    internal func execute(stage: SceneType.TransitionType.StageType) {
        
    }
}

struct SceneRequestImpl<GeneratorType: SceneGenerator> : SceneRequest {
    
    private let method: (_ stage: GeneratorType.SceneType.TransitionType.StageType, _ newScene: GeneratorType.SceneType, _ prevScene: SceneBase) -> Void
    private let stage: GeneratorType.SceneType.TransitionType.StageType
    private let argument: GeneratorType.SceneType.ArgumentType?
    private let generator: GeneratorType
    
    private let manager: SceneManager
    private let sequence: AnyObject
    private let scenario: Scenario?
    
    func execute() {
        guard let scene = generator.generate() else {
            assert(false,  "SceneRequest fail to make scene")
        }
        scene.setup(sequence: sequence, stage: stage, argument: argument, manager: manager, scenario: scenario)
        method(stage, scene, scene)
    }
    
    init(generator: GeneratorType,
         sequence: AnyObject,
         stage: GeneratorType.SceneType.TransitionType.StageType,
         manager: SceneManager,
         scenario: Scenario?,
         argument: GeneratorType.SceneType.ArgumentType?,
         f: @escaping (_ stage: GeneratorType.SceneType.TransitionType.StageType,  _ newScene: GeneratorType.SceneType, _ prevScene: SceneBase) -> Void) {
        
        self.method = f
        self.stage = stage
        self.generator = generator
        self.manager = manager
        self.scenario = scenario
        self.sequence = sequence
        self.argument = argument
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

