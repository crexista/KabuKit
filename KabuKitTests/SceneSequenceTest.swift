//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import XCTest
@testable import KabuKit

class SceneSequenceTest: XCTestCase {
    
    var builder: SceneSequenceBuilder<MockFirstScene, MockGuide, Buildable, Buildable>?
    
    override func setUp() {
        super.setUp()
        builder = SceneSequenceBuilder(scene: MockFirstScene(), guide: MockGuide()).setup(MockStage(), with: "test")
    }
    
    func test_Sequenceをactivateした時_invoke済みでない場合invokeが呼ばれる(){
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        var isInvoke = false
        let seq = builder?.build(onInvoke: { (stage, scene) in
            isInvoke = true
        })

        seq?.activate { (complete) in
            asyncExpection?.fulfill()
        }
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertTrue(isInvoke)
    }
    
    func test_Sequenceをactivateした時_invoke済みの場合_invokeは呼ばれない() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection2: XCTestExpectation? = self.expectation(description: "wait")

        var isInvoke = false
        let seq = builder?.build(onInvoke: { (stage, scene) in
            isInvoke = true
        })

        seq?.activate { (complete) in
            asyncExpection1?.fulfill()
        }
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        XCTAssertTrue(isInvoke)
        
        isInvoke = false
        XCTAssertFalse(isInvoke)
        seq?.activate { (complete) in
            asyncExpection2?.fulfill()
        }
        self.wait(for: [asyncExpection2!], timeout: 2.0)
        XCTAssertFalse(isInvoke)
    }
    
    func test_Sequenceをactiavteした時_現状Sequnceに追加されているSceneをonActivateで取得できる() {
        let asyncExpection: XCTestExpectation? = self.expectation(description: "wait")
        var isInvoke = false
        var isActivate = false
        let seq = builder?.build(onInvoke: { (stage, scene) in
            isInvoke = true
        }, onActive: { (stage, screens) in
            isActivate = true
            XCTAssertEqual(screens.count, 1)
        })

        XCTAssertFalse(isActivate)

        seq?.activate { (complete) in
            asyncExpection?.fulfill()
        }
        self.wait(for: [asyncExpection!], timeout: 2.0)
        XCTAssertTrue(isActivate)
        XCTAssertTrue(isInvoke)
    }
    
    func test_Sequenceがactivate状態時_再度activateを呼んでもactivateは呼ばれない() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection2: XCTestExpectation? = self.expectation(description: "wait")

        var isActivate = false
        let seq = builder?.build(onInvoke: { (stage, scene) in
        }, onActive: { (stage, screens) in
            isActivate = true
            XCTAssertEqual(screens.count, 1)
        })
        XCTAssertFalse(isActivate)
        seq?.activate { (complete) in
            asyncExpection1?.fulfill()
        }
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        XCTAssertTrue(isActivate)
        
        isActivate = false
        XCTAssertFalse(isActivate)
        seq?.activate { (complete) in
            asyncExpection2?.fulfill()
        }
        self.wait(for: [asyncExpection2!], timeout: 2.0)
        XCTAssertFalse(isActivate)
    }
    
    func test_Sequenceがactivate状態時にsuspendした場合_再度activateを呼ぶとonActivateが呼ばれる() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection2: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection3: XCTestExpectation? = self.expectation(description: "wait")
        var isActivate = false
        let seq = builder?.build(onInvoke: { (stage, scene) in
        }, onActive: { (stage, screens) in
            isActivate = true
            XCTAssertEqual(screens.count, 1)
        })

        seq?.activate{ (complete) in
            asyncExpection1?.fulfill()
        }
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        XCTAssertTrue(isActivate)
        isActivate = false
        seq?.suspend({ (complete) in
            asyncExpection2?.fulfill()
        })
        self.wait(for: [asyncExpection2!], timeout: 2.0)
        XCTAssertFalse(isActivate)
        
        seq?.activate({ (complete) in
            asyncExpection3?.fulfill()
        })
        self.wait(for: [asyncExpection3!], timeout: 2.0)
        XCTAssertTrue(isActivate)
    }
    
    func test_Sequenceが起動していない時_suspendをよんでもonSuspendは呼ばれない() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        var isActivate = true
        let seq = builder?.build(onInvoke: { (stage, screens) in
        }, onActive: { (stage, screens) in
            isActivate = true
        }, onSuspend: { (stage, screens) in
            isActivate = false
        })
        seq?.suspend({ (complete) in
            asyncExpection1?.fulfill()
        })
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        XCTAssertTrue(isActivate)
    }
    
    func test_Sequenceが起動している時_suspendをよぶとonSuspendは呼ばれる() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection2: XCTestExpectation? = self.expectation(description: "wait")
        var isActivate = false
        let seq = builder?.build(onInvoke: { (stage, screens) in
        }, onActive: { (stage, screens) in
            isActivate = true
        }, onSuspend: { (stage, screens) in
            isActivate = false
        })
        
        seq?.activate({ (complete) in
            asyncExpection1?.fulfill()
        })
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        XCTAssertTrue(isActivate)
        
        seq?.suspend({ (complete) in
            asyncExpection2?.fulfill()
        })
        self.wait(for: [asyncExpection2!], timeout: 2.0)
        XCTAssertFalse(isActivate)
    }

    func test_Sequenceをsuspendした時_現状表示されているであるSceneがsuspendされる() {
        let asyncExpection1: XCTestExpectation? = self.expectation(description: "wait")
        let asyncExpection2: XCTestExpectation? = self.expectation(description: "wait")
        var isActivate = false
        var screen: Screen?
        let seq = builder?.build(onInvoke: { (stage, screens) in
        }, onActive: { (stage, screens) in
            isActivate = true
        }, onSuspend: { (stage, screens) in
            isActivate = false
            screen = screens.last
        })
        
        seq?.activate({ (complete) in
            asyncExpection1?.fulfill()
        })
        self.wait(for: [asyncExpection1!], timeout: 2.0)
        
        seq?.suspend({ (complete) in
            asyncExpection2?.fulfill()
        })
        self.wait(for: [asyncExpection2!], timeout: 2.0)
        XCTAssertTrue((screen?.isSuspended)!)
        XCTAssertFalse(isActivate)
    }

}
