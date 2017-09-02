import XCTest
@testable import KabuKit

class SceneTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_leaveFromCurrentを実行した時_rewindが登録されていればそのrewindが実行され_leaveじに渡されたreturnValueを受け取れる() {
        let mockScreen = MockSecondScene()
        var isCalled = false
        mockScreen.registerRewind { (arg) in
            isCalled = true
            XCTAssertEqual(arg, "test")
        }
        mockScreen.leaveFromCurrent(returnValue: "test")
        XCTAssertTrue(isCalled)
    }
    
    func test_leaveFromCurrentを実行した時_rewindが登録されていなければそのrewindは実行されずcompletionはfalseを返す() {
        let mockScreen = MockFirstScene()
        var isCalled = false
        mockScreen.leaveFromCurrent { (completion) in
            XCTAssertFalse(completion)
            isCalled = true
        }
        XCTAssertTrue(isCalled)
    }
    
    func test_leaveFromCurrentを実行した時_runTransitionがfalseの場合はrewindは実行されないがcompletionはtrueを返す() {
        let mockScreen = MockFirstScene()
        var isCalled = false

        XCTAssertFalse(isCalled)
        mockScreen.registerRewind { (arg) in
            isCalled = true
        }
        mockScreen.leaveFromCurrnt(runTransition: false) { (result) in
            XCTAssertTrue(result)
        }
        XCTAssertFalse(isCalled)

    }
}
