import XCTest
@testable import KabuKit

class ScreenTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_onSuspendが呼ばれた時_registerSuspendで登録されたsuspend用のメソッドが呼ばれる() {
        let mockScreen = MockFirstScene()
        var isCalled = false
        mockScreen.registerOnSuspend {
            isCalled = true
        }
        mockScreen.onSuspend()
        XCTAssertTrue(isCalled)
    }
    
    func test_onActiveが呼ばれた時_registerActivateで登録されたsuspend用のメソッドが呼ばれる() {
        let mockScreen = MockFirstScene()
        var isCalled = false
        mockScreen.registerOnResume { 
            isCalled = true
        }
        mockScreen.onActivate()
        XCTAssertTrue(isCalled)
    }

}
