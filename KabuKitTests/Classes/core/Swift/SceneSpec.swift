//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneSpec: QuickSpec {

    final class SceneSpecScene : NSObject, Scene {

        typealias RouterType = MockRouter
        typealias ContextType = Void
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        public func willRemove(from stage: NSObject) {

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
                
                let sequence = SceneSequence(NSObject(), firstScene, nil) { (stage, scene) in }

                let scene = SceneSpecScene()

                it("scene#directorはdirectorが入っている") {
                    scene.setup(sequenceObject: sequence, contextObject: nil)
                    expect(scene.director).notTo(beNil())
                }
                
                it("scene#directorが複数回呼び出しても同じインスタンスを返す") {

                    let director1 = scene.director
                    let director2 = scene.director

                    expect(director1 === director2).to(beTrue())
                    expect(director1).notTo(beNil())
                }
            }
        }
    }
}
