//
//  Copyright © 2017年 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneSpec: QuickSpec {

    final class SceneSpecScene : NSObject, Scene2 {

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
        
        describe("var get director") {

            context("setupを呼ぶ前は") {
                let scene = SceneSpecScene()
                it("scene#directorはnil") {
                    expect(scene.director).to(beNil())
                }
            }

            context("setupを呼んだ後") {
                let firstScene = SceneSpecScene()
                let sequence = SceneSequence2(stage: NSObject(), scene: firstScene, argument: nil) { (stage, scene) in }

                let scene = SceneSpecScene()
                beforeEach {
                    scene.setup(sequence: sequence, arguments: nil)
                }
               
                it("scene#directorはdirectorが入っている") {

                    expect(scene.director).notTo(beNil())
                }
                
                it("scene#directorが複数回呼び出しても同じインスタンスを返す") {

                    let director1 = scene.director
                    let director2 = scene.director

                    expect(director1 === director2).to(beTrue())
                }

            }
        }
    }
}
