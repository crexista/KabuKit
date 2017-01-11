//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneSequenceSpec: QuickSpec {
    
    final class SequenceSpecScene1 : NSObject, Scene2 {
        
        typealias RouterType = MockRouter
        
        typealias ArgumentType = Void
        
        public var isRemoved = false
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        public var isRemovable: Bool {
            return true
        }
        
        public func onRemove(stage: NSObject) {
            isRemoved = true
        }
    }
    
    final class SequenceSpecScene2 : NSObject, Scene2 {
        
        typealias RouterType = MockRouter
        
        typealias ArgumentType = Void
        
        public var isRemoved = false
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        public var isRemovable: Bool {
            return false
        }
        
        public func onRemove(stage: NSObject) {
            isRemoved = true
        }
    }

    
    override func spec() {
        
        describe("シーンの追加について") {
            let firstScene = SequenceSpecScene1()

            context("sceneをpushしていない場合") {
                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                sequence.start(producer: nil)
                it("scene#directorはnilを返す") {
                    let scene = SequenceSpecScene1()
                    expect(scene.director).to(beNil())
                }
                it("現在有効なSceneはSequence生成時に指定されたSceneである") {
                    let curent: SequenceSpecScene1? = sequence.currentScene()
                    expect(curent) === firstScene
                }
            }
            
            context("sceneをpushした後") {

                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                sequence.start(producer: nil)
                let secondScene = SequenceSpecScene1()
                var isCalled = false
                let transition = Transition(secondScene, nil) { (stage, scene) in
                    isCalled = true
                }

                sequence.push(transition: transition)

                it("Sceneのセットアップが完了する") {
                    expect(secondScene.director).notTo(beNil())
                    expect(isCalled).to(beTrue())
                }
                
                it("現在有効なSceneはPushされたSceneである") {
                    let curent: SequenceSpecScene1? = sequence.currentScene()
                    expect(curent) === secondScene
                }
            }
        }
        
        describe("シーンの削除について") {
            context("Sceneが1つしかない場合は") {
                let firstScene = SequenceSpecScene1()
                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                sequence.start(producer: nil)
                it("何も起きない") {
                    let previous: SequenceSpecScene1? = sequence.currentScene()
                    let isRemoved = sequence.release(scene: firstScene)
                    let current: SequenceSpecScene1? = sequence.currentScene()
                    expect(current).notTo(beNil())
                    expect(previous) === current
                    expect(isRemoved) === false
                }
            }
            
            context("Sceneは2つ以上あるが削除指定されたSceneが現在有効なシーンでない場合") {
                let firstScene = SequenceSpecScene1()
                let secondScene = SequenceSpecScene1()
                
                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                let transition = Transition(secondScene, nil) { (stage, scene) in }
                sequence.start(producer: nil)
                sequence.push(transition: transition)
                
                let previous: SequenceSpecScene1? = sequence.currentScene()
                expect(previous) === secondScene
                let result = sequence.release(scene: firstScene)
                
                it("何も起きない") {
                    let current: SequenceSpecScene1? = sequence.currentScene()
                    expect(current).notTo(beNil())
                    expect(current) === secondScene
                    expect(result) === false
                }
            }
            
            context("Sceneが2つ以上ありSceneが全て削除可能状態にある場合は") {
                let firstScene = SequenceSpecScene1()
                let secondScene = SequenceSpecScene1()
                
                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                let transition = Transition(secondScene, nil) { (stage, scene) in }
                sequence.start(producer: nil)
                sequence.push(transition: transition)
                expect(firstScene.isRemoved).to(beFalse())
                expect(secondScene.isRemoved).to(beFalse())
                let previous: SequenceSpecScene1? = sequence.currentScene()
                let isRemoved: Bool = sequence.release(scene: secondScene)


                it("SequenceのcurrentSceneが前のSceneになる") {
                    let current: SequenceSpecScene1? = sequence.currentScene()
                    
                    expect(current).notTo(beNil())
                    expect(current) === firstScene
                    
                    expect(previous) !== current
                    expect(previous) === secondScene
                    expect(isRemoved) === true
                    
                }
                
                it("削除の際にisRemoveが呼ばれる") {
                    expect(firstScene.isRemoved).to(beFalse())
                    expect(secondScene.isRemoved).to(beTrue())
                }
            }
            
            context("シーン側の理由で削除できない場合は") {

                let firstScene = SequenceSpecScene1()
                let sequence = SceneSequence2(NSObject(), firstScene, nil){ (stage, scene) in }
                let secondScene = SequenceSpecScene2()
                let transition = Transition(secondScene, nil){ (stage, scene) in }

                sequence.start(producer: nil)
                sequence.push(transition: transition)

                it("SequnceのcurrentSceneは変わらず、Sceneのremovedも呼ばれない") {
                    let previous: SequenceSpecScene2? = sequence.currentScene()
                    let isRemoved: Bool = sequence.release(scene: secondScene)
                    let current: SequenceSpecScene2? = sequence.currentScene()
                    expect(current).notTo(beNil())
                    expect(previous) === current
                    expect(secondScene.isRemoved) === false
                    expect(isRemoved) === false
                }

            }
        }
    }
}
