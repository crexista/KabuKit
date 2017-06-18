import Foundation
import KabuKit

class MockGuide: Guide {
    
    typealias Stage = MockStage
    
    var calledFirstToFirst: Bool = false
    
    var calledFirstToSecond: Bool = false
    
    var calledSecondToFirst: Bool = false
    
    var calledSecondToSecond: Bool = false
    
    let tmpSecondScene: MockSecondScene = MockSecondScene()

    func start(with operation: KabuKit.Operation<MockStage>) {

        operation.at(MockFirstScene.self) { (scenario) in
            scenario.given(link: MockScenarioRequest1.self,
                           to: makeFirstScene,
                           begin: firstToFirst) { (args) in
                            
                            self.reset()
            }
            
            scenario.given(link: MockScenarioRequest2.self, to: makeSecondScene, begin: firstToSecond) { (args) in
                self.reset()
            }
            
            scenario.given(link: MockScenarioRequest3.self, to: {
                self.calledFirstToSecond = true
                return self.tmpSecondScene
            }, begin: firstToSecond) { (args) in
                self.reset()
            }
        
        operation.at(MockSecondScene.self) { (scenario) in
            
            scenario.given(link: MockScenarioRequest1.self,
                           to: makeFirstScene,
                           begin: secondToFirst) { (args) in
                self.reset()
            }

            scenario.given(link: MockScenarioRequest2.self,
                           to: makeSecondScene,
                           begin: secondToSecond) { (args) in
                self.reset()
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
