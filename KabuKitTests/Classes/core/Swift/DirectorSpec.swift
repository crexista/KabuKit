//
//  Copyright © 2017 crexista
//

import Foundation
import XCTest
import Quick
import Nimble

@testable import KabuKit

class DirectorSpec: QuickSpec {
    
    final class DirectorSpecScene1 : NSObject, Scene, SceneLinkage {
        
        typealias DestinationType = MockDestination
        
        typealias ContextType = Void
        
        public var isTransit = false
        
        public var isRemovable: Bool {
            return true
        }
        
        func guide(to destination: DestinationType) -> SceneTransition<DestinationType.StageType>? {
            return destination.specify(DirectorSpecScene(), nil) { (stage, scene) in
                self.isTransit = true
            }
        }
        
        public func willRemove(from stage: NSObject) {
        }
    }
    
    final class DirectorSpecScene : NSObject, Scene, SceneLinkage {
        
        typealias DestinationType = MockDestination
        
        typealias ContextType = Void
        
        public var isTransit = false
        
        public var isRemoved = false
        
        public var isRemovable: Bool {
            return true
        }
        
        func guide(to destination: DestinationType) -> SceneTransition<DestinationType.StageType>? {
            return destination.specify(DirectorSpecScene(), nil) { (stage, scene) in
                self.isTransit = true
            }
        }
        
        public func willRemove(from stage: NSObject) {
            isRemoved = true
        }
    }
    
    override func spec() {
        
        describe("Directorの次のSceneへの遷移について") {
            it("遷移requestが投げられると遷移する") {
                let scene = DirectorSpecScene1()
                let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                _ = sequence.start(producer: nil)
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beFalse())
                director.forwardTo(MockDestination())
                expect(scene.isTransit).to(beTrue())
                expect(sequence.manager.count) == 2
            }
            
            it("backへのrequestが投げれらると戻る") {
                let scene = DirectorSpecScene1()
                let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                _ = sequence.start(producer: nil)
                
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beFalse())
                director.forwardTo(MockDestination())
                expect(scene.isTransit).to(beTrue())
                expect(sequence.manager.count) == 2

                let currentScene: DirectorSpecScene? = sequence.manager.currentScene()
                currentScene?.director?.back()
                expect(sequence.manager.count) == 1
                expect(scene.isTransit).to(beTrue())
            }

        }

    }
}
