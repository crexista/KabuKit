import Foundation
import KabuKit

class MockGuide: Guide {
    
    typealias Stage = MockStage
    
    var calledFirstToFirst: Bool = false
    
    var calledFirstToSecond: Bool = false
    
    var calledSecondToFirst: Bool = false
    
    var calledSecondToSecond: Bool = false

    /// leaveを実行した際にrewindイベントが呼び出されたかどうかを保持します
    var wasRunRewindHandler: Bool = false
    
    let tmpSecondScene: MockSecondScene = MockSecondScene()

    func start(with operation: KabuKit.SceneOperation<MockStage>) {

        operation.at(MockFirstScene.self) { (scenario) in
            
            scenario.given(MockScenarioRequest1.self, makeFirstScene) { (args) in
                self.firstToFirst(args: args)
                return {
                    self.reset()
                }
            }
            
            scenario.given(MockScenarioRequest2.self, makeSecondScene) { (args) in
                self.firstToSecond(args: args)
                return {
                    self.reset()
                }
            }
            
            scenario.given(MockScenarioRequest3.self, { () -> MockSecondScene in
                self.calledFirstToSecond = true
                return self.tmpSecondScene
            }) { (args) in
                self.firstToSecond(args: args)
                return {
                    self.wasRunRewindHandler = true
                    self.reset()
                }
            }

        
        operation.at(MockSecondScene.self) { (scenario) in
            
            scenario.given(MockScenarioRequest1.self, makeFirstScene){ (args) in
                self.secondToFirst(args: args)
                return {
                    self.reset()
                }
            }
            
            scenario.given(MockScenarioRequest2.self, makeSecondScene){ (args) in
                self.secondToSecond(args: args)
                return {
                    self.reset()
                }
            }
            

            }
        }
    }
    
    func reset() {
        self.calledFirstToFirst = false
        self.calledFirstToSecond = false
        self.calledSecondToFirst = false
        self.calledSecondToSecond = false
        
    }
    
    func makeFirstScene() -> MockFirstScene {
        return MockFirstScene()
    }
    
    func makeSecondScene() -> MockSecondScene {
        return MockSecondScene()
    }
    
    func firstToFirst(args: (from: MockFirstScene, next: MockFirstScene, stage: MockStage)) {
        calledFirstToFirst = true
    }
    
    func firstToSecond(args: (from: MockFirstScene, next: MockSecondScene, stage: MockStage)) {
        calledFirstToSecond = true
    }
    
    func secondToFirst(args: (from: MockSecondScene, next: MockFirstScene, stage: MockStage)) {
        calledSecondToFirst = true
    }
    
    func secondToSecond(args: (from: MockSecondScene, next: MockSecondScene, stage: MockStage)) {
        calledSecondToSecond = true
    }

}
