//
//  Copyright © 2016 crexista.
//

import Foundation

public class SceneContext<StageType: AnyObject> {
    
    internal unowned let manager: SceneManager
    internal unowned let stage: StageType
    internal unowned let sequence: AnyObject
    internal unowned let scene: SceneBase
    
    internal weak var scenario: Scenario?
    
    public func sceneRequest<T: SceneGenerator>(_ generator: T,
                                                _ argument: T.SceneType.ArgumentType?,
                                                _ setup: @escaping (_ stage: T.SceneType.TransitionType.StageType, _ newScene: T.SceneType, _ prevScene: SceneBase) -> Void) -> SceneRequest where StageType == T.SceneType.TransitionType.StageType {

        return SceneRequestImpl(generator: generator,
                                sequence: sequence,
                                stage: stage,
                                manager: manager,
                                scenario: scenario,
                                argument: argument,
                                f: setup)
    }
    

    public func sequenceRequest(_ setup: @escaping () -> AnyObject) -> SceneRequest {
        return ScenarioRequestImpl(sequence: sequence, scene: scene, stage: stage, scenario: scenario, f: setup)
    }

    deinit {
        print("SceneContext deinit")
    }
    
    init(_ sequence: AnyObject, _ scene: SceneBase, _ stage: StageType, _ manager: SceneManager, _ scenario: Scenario?) {
        self.stage = stage
        self.manager = manager
        self.scenario = scenario
        self.sequence = sequence
        self.scene = scene
    }
    
}
