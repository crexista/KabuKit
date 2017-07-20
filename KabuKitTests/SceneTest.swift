import XCTest
@testable import KabuKit

class SceneTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
     `context` 値取得テストのためのクラス
     */
    class ContextValueFetchDummy {
        class DummyScene: Scene {
            typealias Context = String
        }
    }

    func test_Contextの値が取得できる() {
        // Context値として期待される定数値
        let contextStringValue = "context value"

        // Context値をストアに設定する
        let scene = ContextValueFetchDummy.DummyScene()
        let hashwrap = ScreenHashWrapper(scene)
        contextByScreen[hashwrap] = contextStringValue

        // 値をストアから取得できるか
        XCTAssert(scene.context != nil, "contextは非nilでなければならない")
        XCTAssertEqual(scene.context, contextStringValue, "設定したContext値と一致しなければならない")
    }

}
