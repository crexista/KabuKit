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
        
        describe("observerへのリクエストについて") {
            
            context("setupを呼ぶ前は") {
                let scene = ActionSceneSpecScene()
                it("observerをリクエストしても中身は空") {
                    expect(scene.observer).to(beNil())
                }
            }
            
            context("setupを呼んだ後") {
                let firstScene = ActionSceneSpecScene()
                let sequence = SceneSequence(NSObject(), firstScene, nil) { (stage, scene) in }
                let scene = ActionSceneSpecScene()
                
                beforeEach {
                    scene.setup(sequenceObject: sequence, argumentObject: nil)
                }
                
                it("Observerは初期化されて取得できる") {
                    
                    expect(scene.observer).notTo(beNil())
                }
                
                it("Observerを複数回呼び出しても同じインスタンスを返す") {
                    
                    let observer1 = scene.observer
                    let observer2 = scene.observer
                    
                    expect(observer1) === observer2
                }
                
            }
        }
    }
}
