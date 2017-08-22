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
    
    private let anyTransitionProcedureName: String = "fuck"
    
    private let stage: Stage
    
    private let transitionQueue: DispatchQueue
    
    private weak var collection: SceneCollection<Stage>?
    

    /**
     指定したSceneでのScenarioのフローを定義します
     
     ```Swift
     operation.at(SampleScene.self) { (scenario) in
         scenario.given(request: SampleRequest.self, to: { () -> Scene in
     
         }, begin: { (args) in
     
         }, end: { (args) in
     
         })
     }
     
     ```
     - Parameters:
       - fromType: Sceneを実装したクラスのtype
       - run: Scenarioを使ったフロー
     */
    public func at<FromSceneType: Scene>(_ fromType: FromSceneType.Type, _ run: (Scenario<FromSceneType, Stage>) -> Void){
        let scenario = Scenario<FromSceneType, Stage>(stage, collection, transitionQueue)
        scenedTransitionProcedure[String(reflecting: fromType)] = scenario
        run(scenario)
    }
    
    
    /**
     Sceneを指定せずにScenarioをフローを定義します
     
     ```Swift
     operation.atAnyScene { (scenario) in
         scenario.given(request: SampleRequest.self, to: { () -> Scene in

         }, begin: { (args) in
 
         }, end: { (args) in

         })
     }

     ```     
     - Parameters:
       - run: Scenarioを使ったフロー
     */
//    public func atAnyScene(run: (Scenario<AnyTransitionProcedure, StageType>) -> Void){
//        anyTransitionProcedure = anyTransitionProcedure ?? Scenario<AnyTransitionProcedure, StageType>(AnyTransitionProcedure.self)
//        guard let scenario = anyTransitionProcedure as? Scenario<AnyTransitionProcedure, StageType> else { return }
//        scenedTransitionProcedure[anyTransitionProcedureName] = scenario
//        run(scenario)
//    }
    
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

/*
public class AnyTransitionProcedure: Screen {
    public /**
     このScreenが一度でも表示状態になったかどうかです
     
     */
    var isStarted: Bool

    internal init() {}
}
*/
