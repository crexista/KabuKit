//
//  Copyright © 2017 crexista
//

import Foundation

import XCTest
import Quick
import Nimble

@testable import KabuKit

class ViewControllerXIBSpec: QuickSpec {
    
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
        
        describe("generate") {
            context("指定したクラスがSceneを実装したUIViewControllerクラスである") {
                
                it("nibファイル名が正しい場合はUIViewControllerのViewを生成できる") {
                    let xib = ViewControllerXIB(sceneClass: MockUIViewController.self, nibName: "MockUIViewController", bundle: Bundle(for: MockUIViewController.self))
                    let scene = xib.generate()
                    expect(scene).notTo(beNil())
                    expect(scene?.view).notTo(beNil())
                }
            }
        }
    }
}
