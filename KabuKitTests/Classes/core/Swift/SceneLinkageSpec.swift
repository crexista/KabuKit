//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneLinkageSpec: QuickSpec {

    
    final class LinkageSpecScene1 : NSObject, Scene, SceneLinkage {
        
        typealias DestinationType = MockDestination
        
        typealias ArgumentType = Void
        
        public var isTransit = false
        
        public var isRemovable: Bool {
            return false
        }
        
        func onMove(destination: MockDestination) -> Transition<NSObject>? {
            return nil
        }
        
        public func onRemove(stage: NSObject) {
        }
    }

    override func spec() {
        
        describe("var get router") {
            context("Sceneに実装された場合") {
                it("routerはselfを返す") {
                    let scene = LinkageSpecScene1()
                    expect(scene.router) === scene
                }
            }
        }
    }
}
