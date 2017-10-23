//
//  Copyright © 2017 crexista
//

import Foundation

/**
 どのSceneでどのようなScenarioを実行するかをまとめたクラス
 
 */
public class SceneOperation<FirstScene: Scene, Stage> {
    
    private var scenedTransitionProcedure = [String : TransitionProcedure]()
    
    private var anyTransitionProcedure: TransitionProcedure?
    
    private let anyTransitionProcedureName: String = "anyTransition"
    
    private let stage: Stage
    
    let transitionQueue: DispatchQueue
    
    public private(set) weak var sequence: SceneSequence<FirstScene, Stage>?
    

    public func at<FromSceneType: Scene>(_ fromType: FromSceneType.Type, _ run: (Scenario<FirstScene, Stage>) -> Void){
        let scenario = Scenario<FirstScene, Stage>(stage, sequence, transitionQueue)
        scenedTransitionProcedure[String(reflecting: fromType)] = scenario
        run(scenario)
    }
    
    
    internal func resolve(from: Screen) -> TransitionProcedure? {
        let name = String(reflecting: type(of: from))
        return scenedTransitionProcedure[name]
    }
    
    internal func resolve() -> TransitionProcedure? {
        return scenedTransitionProcedure[anyTransitionProcedureName]
    }

    internal init(stage: Stage, queue: DispatchQueue, sequence: SceneSequence<FirstScene, Stage>) {
        self.stage = stage
        self.transitionQueue = queue
        self.sequence = sequence
    }
}

