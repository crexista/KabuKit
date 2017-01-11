//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneRequestSpec: QuickSpec {
    
    final class SceneRequestScene : NSObject, Scene {
        
        typealias RouterType = MockRouter
        typealias ArgumentType = Void
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        public var isRemovable: Bool {
            return false
        }
        
        public func onRemove(stage: NSObject) {
            
        }
    }
    
    override func spec() {
        
        
        
        describe("Transition生成について") {

            it("makeTransitionを呼ぶとTransitionを生成することができる") {
                var isCalled = false
                let request = MockDestination()
                let scene = SceneRequestScene()

                let transition = request.makeTransition(scene, nil, { (stage, scene) in
                    isCalled = true
                })
                expect(isCalled).to(beFalse())
                transition?.execution(NSObject(), scene)

                expect(isCalled).to(beTrue())
            }
        }
    }
}
