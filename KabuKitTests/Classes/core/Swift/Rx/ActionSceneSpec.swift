//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class ActionSceneSpec: QuickSpec {
    
    final class ActionSceneSpecScene : NSObject, ActionScene {
        
        typealias RouterType = MockRouter
        typealias ContextType = Void
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        public var isRemovable: Bool {
            return false
        }
        
        public func willRemove(from stage: NSObject) {
            
        }
    }
    
    override func spec() {
        
        describe("ActionSceneのプロパティへのリクエストについて") {
            
            context("setupを呼ぶ前は") {
                let scene = ActionSceneSpecScene()
                it("リクエストしても中身は空") {
                    expect(scene.activator).to(beNil())
                    expect(scene.context).to(beNil())
                    expect(scene.director).to(beNil())
                }
            }
            
            context("setupを呼んだ後") {
                let firstScene = ActionSceneSpecScene()
                let sequence = SceneSequence(NSObject(), firstScene, nil) { (stage, scene) in }

                let scene = ActionSceneSpecScene()
                
                beforeEach {
                    scene.setup(sequenceObject: sequence, contextObject: nil)
                }
                
                it("activatorは初期化されて取得できる") {
                    expect(scene.activator).notTo(beNil())
                    expect(scene.director).notTo(beNil())
                }
                
                it("activatorを複数回呼び出しても同じインスタンスを返す") {
                    
                    let activator1 = scene.activator
                    let activator2 = scene.activator
                    
                    expect(activator1) === activator2
                }
                
            }
        }
    }
}
