//
//  Copyright © 2017 crexista
//

import Foundation

/**
 どのSceneでどのようなScenarioを実行するかをまとめたクラス
 
 */
public class SceneOperation<Stage> {
    
    private var scenedTransition = [String : Transition]()
    
    private var anyTransition: Transition?
    
    private let anyTransitionName: String

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
        scenedTransition[scenario.name] = scenario
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
    public func atAnyScene(run: (Scenario<AnyTransition, Stage>) -> Void){
        anyTransition = anyTransition ?? Scenario<AnyTransition, Stage>(AnyTransition.self)
        guard let scenario = anyTransition as? Scenario<AnyTransition, Stage> else { return }
        scenedTransition[anyTransitionName] = scenario
        run(scenario)
    }
    
    internal func resolve(from: Screen) -> Transition? {
        let name = String(reflecting: type(of: from))
        return scenedTransition[name]
    }
    
    internal func resolve() -> Transition? {
        return scenedTransition[anyTransitionName]
    }

    internal init() {
        anyTransitionName = String(reflecting: AnyTransition.self)
    }
}

public class AnyTransition: Screen {
    internal init() {}
}
