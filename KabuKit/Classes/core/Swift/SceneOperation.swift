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
    
    private let anyTransitionProcedureName: String

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
    public func at<From: Scene>(_ fromType: From.Type, _ run: (Scenario<From, Stage>) -> Void) {
        let scenario = Scenario<From, Stage>(fromType)
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
    public func atAnyScene(run: (Scenario<AnyTransitionProcedure, Stage>) -> Void){
        anyTransitionProcedure = anyTransitionProcedure ?? Scenario<AnyTransitionProcedure, Stage>(AnyTransitionProcedure.self)
        guard let scenario = anyTransitionProcedure as? Scenario<AnyTransitionProcedure, Stage> else { return }
        scenedTransitionProcedure[anyTransitionProcedureName] = scenario
        run(scenario)
    }
    
    internal func resolve(from: Screen) -> TransitionProcedure? {
        let name = String(reflecting: type(of: from))
        return scenedTransitionProcedure[name]
    }
    
    internal func resolve() -> TransitionProcedure? {
        return scenedTransitionProcedure[anyTransitionProcedureName]
    }

    internal init() {
        anyTransitionProcedureName = String(reflecting: AnyTransitionProcedure.self)
    }
}

public class AnyTransitionProcedure: Screen {
    internal init() {}
}
