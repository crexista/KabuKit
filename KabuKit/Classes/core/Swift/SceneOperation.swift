//
//  Copyright © 2017 crexista
//

import Foundation

/**
 どのSceneでどのようなScenarioを実行するかをまとめたクラス
 
 */
public class SceneOperation<StageType> {
    
    private var scenedTransitionProcedure = [String : TransitionProcedure]()
    
    private var anyTransitionProcedure: TransitionProcedure?
    
    private let anyTransitionProcedureName: String
    
    private let stage: StageType
    
    private unowned var iterator: SceneIterator

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
    public func at<FromSceneType: Scene>(_ fromType: FromSceneType.Type, _ run: (Scenario<FromSceneType, StageType>) -> Void) {
        let scenario = Scenario<FromSceneType, StageType>(fromType, iterator, stage)
        scenedTransitionProcedure[scenario.name] = scenario
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

    internal init(stage: StageType, iterator: SceneIterator) {
        anyTransitionProcedureName = String(reflecting: AnyTransitionProcedure.self)
        self.iterator = iterator
        self.stage = stage
    }
}

public class AnyTransitionProcedure: Screen {
    internal init() {}
}
