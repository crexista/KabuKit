//
//  Copyright © 2017 crexista
//

import XCTest
@testable import KabuKit

class ScenarioTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
/*
    func test_givenでRequestに紐づけられたbeginのメソッドのみtransitの際に呼ばれる() {
        let firstScene = MockFirstScene()
        let stage = MockStage()
        let container = DummyContainer()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        let scenario = Scenario<MockFirstScene, MockStage>(MockFirstScene.self, container, stage)
        var isBeginCalled = false
        var isEndCalled = false
        var isSetupCalled = false
        scenario.given(MockScenarioRequest1.self, { () in MockSecondScene() }) { (args) in
            isBeginCalled = true
            return {
                isEndCalled = true
            }
        }

        scenario.start(at: MockScenarioRequest1()) { (complete) in
            XCTAssertTrue(isBeginCalled)
            isSetupCalled = true
            asyncExpection?.fulfill()
        }
        self.wait(for: [asyncExpection!], timeout: 2.0)
        
        XCTAssertFalse(isEndCalled)
        XCTAssertTrue(isSetupCalled)
    }
    
    func test_transitを呼ぶ前にbackを呼んでも何もおきない() {
        let scenario = Scenario<MockFirstScene, MockStage>(MockFirstScene.self)
        var isBeginCalled = false
        var isEndCalled = false
        scenario.given(MockScenarioRequest1.self, { () in MockSecondScene() }) { (args) in
            isBeginCalled = true
            return {
                isEndCalled = true
            }
        }

        scenario.back(true) { (completion) in

        }
        XCTAssertFalse(isBeginCalled)
        XCTAssertFalse(isEndCalled)
    }
    
    func test_givenでRequestに紐づけられたendのメソッドのみbackの際に呼ばれる() {
        let firstScene = MockFirstScene()
        let container = DummyContainer()
        let stage = MockStage()
        let scenario = Scenario<MockFirstScene, MockStage>(MockFirstScene.self)
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        var isBeginCalled = false
        var isEndCalled = false
        var isSetupCalled = false
        
        scenario.given(MockScenarioRequest1.self, { () in MockSecondScene() }) { (args) in
            isBeginCalled = true
            return {
                isEndCalled = true
            }
        }
        
        scenario.setup(at: firstScene, on: stage, with: container, when: nil)
        scenario.start(at: MockScenarioRequest1()) { (complete) in
            asyncExpection?.fulfill()
            XCTAssertTrue(isBeginCalled)
            isSetupCalled = true
        }
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertFalse(isEndCalled)
        XCTAssertTrue(isSetupCalled)
        container.back?()
        XCTAssertTrue(isEndCalled)
    }
*/
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
