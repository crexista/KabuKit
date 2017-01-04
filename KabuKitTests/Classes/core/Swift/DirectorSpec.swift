//
//  Copyright © 2017年 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class DirectorSpec: QuickSpec {
    
    final class DirectorSpecScene1 : NSObject, Scene2, SceneLinkage {
        
        typealias DestinationType = MockDestination
        
        typealias ArgumentType = Void
        
        public var isTransit = false
        
        public var isRemovable: Bool {
            return true
        }
        
        func onMove(destination: MockDestination) -> Transition<NSObject>? {
            return destination.makeTransition(newScene: DirectorSpecScene2()) { (stage, scene) in
                self.isTransit = true
            }
        }
        
        public func onRemove(stage: NSObject) {
        }
    }
    
    final class DirectorSpecScene2 : NSObject, Scene2, SceneLinkage {
        
        typealias DestinationType = MockDestination
        
        typealias ArgumentType = Void
        
        public var isTransit = false
        
        public var isRemoved = false
        
        public var isRemovable: Bool {
            return true
        }
        
        func onMove(destination: MockDestination) -> Transition<NSObject>? {
            return destination.makeTransition(newScene: DirectorSpecScene2()) { (stage, scene) in
                self.isTransit = true
            }
        }
        
        public func onRemove(stage: NSObject) {
            isRemoved = true
        }
    }
    
    override func spec() {
        
        describe("Directorの次のSceneへの遷移について") {
            it("遷移requestが投げられると遷移する") {
                let scene = DirectorSpecScene1()
                let sequence = SceneSequence2(stage: NSObject(), scene: scene, argument: nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                sequence.start(producer: nil)
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beFalse())
                director.transitTo(request: MockDestination())
                expect(scene.isTransit).to(beTrue())
                expect(sequence.manager.count) == 2
            }
            
            it("backへのrequestが投げれらると戻る") {
                let scene = DirectorSpecScene1()
                let sequence = SceneSequence2(stage: NSObject(), scene: scene, argument: nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                sequence.start(producer: nil)
                
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beFalse())
                director.transitTo(request: MockDestination())
                expect(scene.isTransit).to(beTrue())
                expect(sequence.manager.count) == 2

                let currentScene: DirectorSpecScene2? = sequence.manager.currentScene()
                currentScene?.director?.back()
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beTrue())
            }

        }

    }
}
