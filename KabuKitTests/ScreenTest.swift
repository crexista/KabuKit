import XCTest
@testable import KabuKit

class ScreenTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     `send<ContextType>(_ request: TransitionRequest<ContextType>) -> Void` のテストを行うためのクラス
     */
/*
    class SendWithRequestDummy {
        class DummySceneSequence: Guide {
            typealias Stage = UINavigationController

            /// テスト用の状態変更調査フラグ
            public var wasTransitionExecuted = false

            func start(with operation: SceneOperation<UINavigationController>) {
                operation.at(DummyScene.self) { (scenario) in
                    scenario.given(DummySceneRequest.self, { DummyScene() }, { (args) in
                        // この関数が実行された場合、フラグを変更する
                        self.wasTransitionExecuted = true

                        return {}
                    })
                }
            }
        }

        class DummySceneRequest: Request<Void> {}

        class DummyScene: Scene {
            typealias Context = Void

            /**
             遷移を実行する
             */
            public func transit() {
                send(DummySceneRequest())
            }
        }
    }
*/
    func test_send_with_requestを実行し遷移することができる() {
        // For testing
//        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
//
//        let dummySceneSequence = SendWithRequestDummy.DummySceneSequence()
//        let sequence = SceneSequence<Void, SendWithRequestDummy.DummySceneSequence>(dummySceneSequence)
//
//        sequence.startWith(UINavigationController(), SendWithRequestDummy.DummyScene(), ()) { (scene, stage) in
//            // 遷移を実行する
//            scene.transit()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                XCTAssertTrue(dummySceneSequence.wasTransitionExecuted, "Transitionが実行されないといけない")
//                asyncExpection?.fulfill()
//            }
//        }
//
//        // For testing
//        self.wait(for: [asyncExpection!], timeout: 3.0)
    }

}
