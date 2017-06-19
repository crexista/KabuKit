//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import XCTest
@testable import KabuKit

class ScreenHashWrapperTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_同じクラスインスタンスをラップした場合はwrapperが別クラスだとしても比較するとtrueになる() {
        let dummy = MockFirstScene()
        let wrapper1 = ScreenHashWrapper(dummy)
        let wrapper2 = ScreenHashWrapper(dummy)
        
        XCTAssertTrue(wrapper1 == wrapper2)
    }
    
    func test_違うクラスインスタンスをラップした場合は比較するとfalseになる() {
        let dummy1 = MockFirstScene()
        let dummy2 = MockFirstScene()
        let wrapper1 = ScreenHashWrapper(dummy1)
        let wrapper2 = ScreenHashWrapper(dummy2)
        
        XCTAssertFalse(wrapper1 == wrapper2)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class DummyUIViewScene: UIView, Scene {
    typealias ContextType = Void
}
