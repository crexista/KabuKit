//
//  Copyright © 2017 crexista
//

import Foundation

import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneSequenceSpec: QuickSpec {
    
    class MockTransition : SceneTransition {
        typealias StageType = UIView
        
        func request(context: SceneContext<UIView>) -> SceneRequest? {
            return nil
        }
    }
    
    class MockScene : NSObject, Scene {
        public var isRemovable: Bool {
            return false
        }
        
        typealias ArgumentType = Void
        typealias TransitionType = MockTransition
        
        func onRemove(stage: UIView) {
            
        }
    }
    
    override func spec() {
        
        describe("start") {
            context("Sceneがまだ一つも生成されていない") {
                it("SceneGeneratorからSceneを生成し、Sceneをsetupしたのちinvokeが呼ばれる") {
                    
                }
            }
            
            context("Sceneがすでに1つ以上生成されたあと") {
                it("SceneGeneratorからSceneを生成し、Sceneをsetupしたのちinvokeが呼ばれる") {
                    
                }
            }
            
        }
    }
}
