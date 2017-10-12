//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import XCTest
@testable import KabuKit

class SceneCollectionTests: XCTestCase {
    
    var collection: SceneCollection<MockStage>?
    let stage = MockStage()
    let guide = MockGuide()
    
    override func setUp() {
        super.setUp()
        collection = SceneCollection(stage: stage, guide: guide)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_Sceneを追加した時_その際に渡したcontextをsceneは保持している() {
        let scene = MockFirstScene()
        let context = "test"
        collection?.add(scene, with: context, transition: { (stage, sce, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        
        XCTAssertEqual(scene.context, context)
    }
    
    func test_Sceneを追加した時_transitionが指定してあれば_それが実行される() {

        let scene = MockFirstScene()
        let context = "test"
        var transitionCalled: Bool = false
        collection?.add(scene, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            transitionCalled = true
            return nil
        }, callbackOf: nil)
        
        XCTAssertTrue(transitionCalled)
    }
    
    func test_Sceneを追加した時_init時に渡されたGuideから割り出されたScenarioがSceneに登録されている() {
        let scene = MockFirstScene()
        let context = "test"

        XCTAssertNil(scene.scenario)
        collection?.add(scene, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        
        XCTAssertNotNil(scene.scenario)
    }

    func test_Sceneを追加した時_Sceneに渡されたScenarioを実行すると次のSceneが追加される() {
        let scene = MockFirstScene()
        let context = "test"
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        
        XCTAssertNil(scene.scenario)
        collection?.add(scene, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        
        XCTAssertNotNil(scene.scenario)
        let request = MockTransitionRequest("test2") { (str) in
            // Nothing
        }
        XCTAssertNil(scene.nextScene)
        scene.scenario?.start(atRequestOf: request, { (completion) in
            asyncExpection?.fulfill()
        })
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertNotNil(scene.nextScene)
        XCTAssertEqual(collection?.screens.count, 2)
    }

    func test_rewindが定義されているSceneをleaveした時_SceneCollectionが持つSceneの数が減る() {
        let scene = MockFirstScene()
        let context = "test"
        
        collection?.add(scene, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return {}
        }, callbackOf: nil)
        
        XCTAssertEqual(collection?.screens.count, 1)
        scene.leaveFromCurrent()
        XCTAssertEqual(collection?.screens.count, 0)
        
    }
    
    func test_rewindが定義されていないSceneをleaveした時_SceneCollectionが持つSceneの数は減らない() {
        let scene = MockFirstScene()
        let context = "test"
        
        collection?.add(scene, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        
        XCTAssertEqual(collection?.screens.count, 1)
        scene.leaveFromCurrent()
        XCTAssertEqual(collection?.screens.count, 1)
        
    }
    
    func test_Sceneが1つ以上ある時_Sceneを追加すると前のSceneの状態がSuspendになる() {
        let scene1 = MockFirstScene()
        let scene2 = MockFirstScene()
        let context = "test"
        
        collection?.add(scene1, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        XCTAssertFalse(scene1.isSuspended)
        XCTAssertTrue(scene2.isSuspended)
        collection?.add(scene2, with: context, transition: { (stage, scene, screen) -> (() -> Void)? in
            return nil
        }, callbackOf: nil)
        XCTAssertTrue(scene1.isSuspended)
        XCTAssertFalse(scene2.isSuspended)

    }
    
}


