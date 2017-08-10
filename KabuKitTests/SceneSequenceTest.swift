//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import XCTest
@testable import KabuKit

class SceneSequenceTest: XCTestCase {
    
    let stage: MockStage = MockStage()
    
    let firstScene: MockFirstScene = MockFirstScene()
    
    let guide = MockGuide()
    
    var sequence: SceneSequence<MockFirstScene, MockGuide>?
    
    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // rewindイベントが呼び出されたかどうかの状態を初期化
        self.guide.wasRunRewindHandler = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_FirstSceneからScenarioRequest1を受けたらcalledFirstToFirstが呼ばれる() {
        let request = MockScenarioRequest1()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        
        XCTAssertFalse(self.guide.calledFirstToFirst)

//        sequence?.start(on: stage, transition: { (scene, stage) in
//            stage.setScene(scene: scene)
//        }, {
//            self.firstScene.sendTransitionRequest(request, { (completion) in
//                XCTAssertTrue(completion)
//                XCTAssertTrue(self.guide.calledFirstToFirst)
//                asyncExpection?.fulfill()
//            })
//        })

        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertTrue(self.guide.calledFirstToFirst)
    }
    

    
    func test_suspendする際のロジックが定義されている時_Sequenceのsuspendを呼んだ場合_suspendロジックが呼ばれ停止状態になる() {
        var isCalled = false
        var isSuspended = false
        var isResumed = false

        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
//        sequence?.start(on: stage, transition: { (scene, stage) in
//            isCalled = true
//        }, onSuspend: { (stage, screens) in
//            isSuspended = true
//        }, onResume: { (stage, screens) in
//            isResumed = true
//        }, onLeave: { (stage, screens, returns) in
//
//        }, { 
//            self.sequence?.suspend()
//            self.sequence?.resume()
//            asyncExpection?.fulfill()
//        })

        self.wait(for: [asyncExpection!], timeout: 2.0)

        XCTAssertTrue(isCalled)
        XCTAssertTrue(isSuspended)
        XCTAssertTrue(isResumed)
    }
    
    func test_rewindする際のロジックが定義されている時_Sequenceに与えられた最初のSceneがleaveを呼んだ場合_最初のSceneはデタッチされonLeaveが呼ばれる() {
        var isRewind = false
        var isLeaved = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        let builder = SceneContainerBuilder.builder(scene: firstScene, guide: guide) { (scene, stage) -> (() -> Void)? in
            return { () in
                isRewind = true
            }
        }
        
        sequence = builder.setStage(stage).setContext(()).build(onLeave: { (stage, screens, _: ()) in
            isLeaved = true
        })

        sequence?.activate {
            asyncExpection?.fulfill()
        }

        self.wait(for: [asyncExpection!], timeout: 2.0)
        firstScene.leaveFromCurrent(returnValue: ())
        XCTAssertTrue(isRewind)
        XCTAssertTrue(isLeaved)
        XCTAssertTrue(!sequence!.contain(firstScene))

    }

    func test_rewindする際のロジックが定義されていない時_Sequenceに与えられた最初のSceneがleaveを呼んでも_最初のSceneはデタッチされずonLeaveも呼ばれない() {
        var isLeave = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        let builder = SceneContainerBuilder.builder(scene: firstScene, guide: guide) { (scene, stage) -> Void in }
        sequence = builder.setContext(()).setStage(stage).build { (stage, screens, value) in
            isLeave = true
        }
        
        sequence?.activate{
            asyncExpection?.fulfill()
        }

//        sequence?.start(on: stage, transition: { (scene, stage) -> Void in
//
//        }, onLeave:{ (stage, scene, returns) in
//            isLeave = true
//        }, {
//            asyncExpection?.fulfill()
//        })
        
        self.wait(for: [asyncExpection!], timeout: 2.0)
        firstScene.leaveFromCurrent(returnValue: ())
        XCTAssertTrue(sequence!.contain(firstScene))
        XCTAssertFalse(isLeave)
    }
    
    func test_rewindする際のロジックが定義されていない時でも_Sequenceのleaveを呼ぶと_最初のSceneはデタッチされonLeaveも呼ばれる() {
        var isLeaved = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        let builder = SceneContainerBuilder.builder(scene: firstScene, guide: guide) { (scene, stage) -> Void in }
        
        sequence = builder.setContext(()).setStage(stage).build { (stage, screens, value) in
            isLeaved = true
        }
        
        sequence?.activate{
            asyncExpection?.fulfill()
        }
        sequence?.suspend()
        
        self.wait(for: [asyncExpection!], timeout: 2.0)
        sequence?.leaveFromCurrent(returnValue: ())
        XCTAssertTrue(isLeaved)

    }
    
    func test_suspendする際のロジックが定義されている時_suspendを呼ぶと_onSuspendが呼ばれる() {
        var isSuspend = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        let builder = SceneContainerBuilder.builder(scene: firstScene, guide: guide) { (scene, stage) -> Void in }
        
        sequence = builder.setContext(()).setStage(stage).build (onSuspend: { (stage, screens) in
            isSuspend = true
        }, onResume: { (stage, screens) in

        }, onLeave: { (stage, screens, value) in

        })

        
        sequence?.activate{
            asyncExpection?.fulfill()
        }
        sequence?.suspend()
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertTrue(isSuspend)
    }
    
    
    func test_rewindする際のロジックが定義されている時_Sequenceのleaveを呼ぶと_onLeaveが呼ばれるがrewindは呼ばれない() {
        var isLeave = false
        var isRewind = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
//        sequence?.start(on: stage, transitionWithRewind: { (scene, stage) -> (() -> Void)? in
//            return { () in
//                isRewind = true
//            }
//        }, onLeave:{ (stage, scene, returns) in
//            isLeave = true
//        }, {
//            asyncExpection?.fulfill()
//        })
        
        self.wait(for: [asyncExpection!], timeout: 2.0)
//        sequence?.leaveFromCurrent()
        XCTAssertTrue(isLeave)
        XCTAssertFalse(isRewind)
    }


    
    func test_leaveする際のロジックが定義されている時_Sequenceのleaveを呼んだ場合_leaveロジックの中で今まで追加されたSceneを取得できる() {
        let secondScreen = MockSecondScene()
        var isCalled = false
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
//        sequence?.start(on: stage, transition: { (scene, stage) in
//
//        }, onLeave: { (stage, screens, value) in
//            XCTAssertTrue(screens[0] === self.firstScene)
//            XCTAssertTrue(screens[1] === secondScreen)
//            isCalled = true
//        }, {
//            self.sequence?.add(screen: secondScreen, {})
//            self.sequence?.leaveFromCurrent(completion: { (result) in
//                asyncExpection?.fulfill()
//            })
//        })
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertTrue(isCalled)

    }
    
/*
    func test_leaveする際のロジックが定義されていない時_Sequenceがleaveを呼んだ場合_最初のSceneはデタッチされない() {
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        sequence?.start(on: stage, with: { (scene, stage) in }, {
            XCTAssertTrue(self.sequence!.contain(self.firstScene))
            self.sequence?.leave{ (comp) in
                asyncExpection?.fulfill()
                XCTAssertTrue(self.sequence!.contain(self.firstScene))
            }
        })

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }
    
    func test_FirstSceneからRequestを受け指定のSceneに遷移したのち指定のSceneでleaveが呼ばれたら戻ってこれる() {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        XCTAssertFalse(self.guide.calledFirstToFirst)
        sequence?.start(on: stage, with: { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                XCTAssertTrue(completion)
                XCTAssertTrue(self.guide.calledFirstToSecond)
                self.guide.tmpSecondScene.leave() {(completion) in
                    XCTAssertFalse(self.guide.calledFirstToSecond)
                    asyncExpection?.fulfill()
                }
            })
        })
        
        self.wait(for: [asyncExpection!], timeout: 2.0)

    }

    /**
     Tests for leave()
     */
    func test_leaveが引数無しで呼び出された場合にはrewindイベントが実行される() {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        sequence?.start(on: stage, with: { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                self.guide.tmpSecondScene.leave()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    XCTAssertTrue(self.guide.wasRunRewindHandler)
                    asyncExpection?.fulfill()
                }
            })
        })

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }

    /**
     Tests for leave(_ runTransition:)
     */
    func leaveTest(runTransition: Bool, wasRunRewindHandlerExpectation: Bool) -> Void {
        let request = MockScenarioRequest3()
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")

        sequence?.start(on: stage, with: { (scene, stage) in
            stage.setScene(scene: scene)
            self.firstScene.send(request, { (completion) in
                self.guide.tmpSecondScene.leave(runTransition)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if wasRunRewindHandlerExpectation {
                        XCTAssertTrue(self.guide.wasRunRewindHandler)
                    } else {
                        XCTAssertFalse(self.guide.wasRunRewindHandler)
                    }
                    asyncExpection?.fulfill()
                }
            })
        })

        self.wait(for: [asyncExpection!], timeout: 2.0)
    }
*/
    func test_leaveが引数trueで呼び出された場合にはrewindイベントが実行される() {
//        self.leaveTest(runTransition: true, wasRunRewindHandlerExpectation: true)
    }

    func test_leaveが引数falseで呼び出された場合にはrewindイベントが実行されない() {
//        self.leaveTest(runTransition: false, wasRunRewindHandlerExpectation: false)
    }

    /**
     `operation.resolve(from: scene) else { return }` の else パターンのテストのためのクラス
     */
    class NoTransitionDefinitionDummy {
        class DummySceneGuide: SequenceGuide {
            typealias Stage = UINavigationController

            public var wasStartCalled = false

            func start(with operation: SceneOperation<UINavigationController>) {
                operation.at(DummyScene.self) { (scenario) in
                    // この関数が呼ばれたかどうかを確認する
                    self.wasStartCalled = true
                }
            }
        }

        class DummySceneRequest: TransitionRequest<Void, Void> {}

        class DummyScene: Scene {
            typealias Context = Void

            public func transit() {
                sendTransitionRequest(DummySceneRequest())
            }
        }
    }

    func test_遷移定義がない時何も実行されない() {
        // For testing
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")

        let dummySceneGuide = NoTransitionDefinitionDummy.DummySceneGuide()
//        let sequence = SceneSequence(scene: NoTransitionDefinitionDummy.DummyScene(), guide: dummySceneGuide, context: ())
//        sequence.start(on: UINavigationController(), transitionWithRewind: { (scene, stage) -> (() -> Void)? in
//            // 遷移を実行する
//            scene.transit()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                XCTAssertTrue(dummySceneGuide.wasStartCalled, "startが呼ばれて何も発生しない")
//                asyncExpection?.fulfill()
//            }
//
//            return { _ in }
//        })
//
//        // For testing
//        self.wait(for: [asyncExpection!], timeout: 3.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
