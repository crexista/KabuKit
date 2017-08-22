//
//  Copyright © 2017 crexista
//

import XCTest
@testable import KabuKit
class MockRequest2: TransitionRequest<Void, Void>{}
class MockFirstScene3: Scene {
    typealias Context = Void
}
class ScenarioTest: XCTestCase {

    let stage = MockStage()
    let guide = MockGuide()

    var collection: SceneCollection<MockStage>?
    var scenario: Scenario<MockFirstScene, MockStage>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        collection = SceneCollection<MockStage>(stage: stage, guide: guide)
        collection?.screens.append(MockFirstScene())
        scenario = Scenario<MockFirstScene, MockStage>(MockStage(), collection, DispatchQueue.main)
        scenario?.given(MockTransitionRequest.self, nextTo: { MockSecondScene() }) { (args) in
            return {}
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_生成されたScenarioに設定されているrequestをstart時に受け取った時_新しいSceneを生成およびCollectionに追加しcompletionがtrueで実行される() {

        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let request = MockTransitionRequest("test") { (str) in }
        var isCalled = false
        XCTAssertEqual(collection?.screens.count, 1)
        scenario?.start(atRequestOf: request, { (result) in
            asyncExpection1?.fulfill()
            XCTAssertTrue(result)
            isCalled = true
        })
        self.wait(for: [asyncExpection1!], timeout: 1.0)
        
        XCTAssertTrue(isCalled)
        XCTAssertEqual(collection?.screens.count, 2)
    }
    
    func test_生成されたScenarioに設定されていないrequestをstart時に受け取った時_SceneCollectionにSceneは追加されずcompletionがfalseで実行される() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let request = MockRequest2()
        var isCalled = false
        XCTAssertEqual(collection?.screens.count, 1)
        scenario?.start(atRequestOf: request, { (result) in
            asyncExpection1?.fulfill()
            XCTAssertFalse(result)
            isCalled = true
        })
        self.wait(for: [asyncExpection1!], timeout: 1.0)
        
        XCTAssertTrue(isCalled)
        XCTAssertEqual(collection?.screens.count, 1)
    }
    
    func test_Scenarioをstartさせてrequestを実行した場合_givenで指定されたSceneがcollectionの末尾に追加される() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        scenario?.given(MockRequest2.self, nextTo: { MockFirstScene3() }, with: { (args) in {} })
        scenario?.start(atRequestOf: MockRequest2(), { (result) in
            asyncExpection1?.fulfill()
            XCTAssertTrue(result)
        })
        self.wait(for: [asyncExpection1!], timeout: 1.0)
        XCTAssertEqual(String(describing: collection!.screens.last!), String(describing: MockFirstScene3()))
    }
    
}
