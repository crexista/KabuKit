//
//  Copyright © 2017 crexista
//

import Foundation

/**
 どのSceneでどのようなScenarioを実行するかをまとめたクラス
 
 */
public class SceneOperation<Stage> {
    
    private var scenedTransitionProcedure = [String : TransitionProcedure]()
    
    private var anyTransitionProcedure: TransitionProcedure?
    
    private let anyTransitionProcedureName: String = "anyTransition"
    
    private let stage: Stage
    
    private let transitionQueue: DispatchQueue
    
    private weak var collection: SceneCollection<Stage>?
    

    public func at<FromSceneType: Scene>(_ fromType: FromSceneType.Type, _ run: (Scenario<FromSceneType, Stage>) -> Void){
        let scenario = Scenario<FromSceneType, Stage>(stage, collection, transitionQueue)
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
    
    func setup(collection:  SceneCollection<Stage>) {
        self.collection = collection
    }

    internal init(stage: Stage, queue: DispatchQueue) {
        self.stage = stage
        self.transitionQueue = queue
    }
}

