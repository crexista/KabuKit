//
//  Copyright © 2017 crexista
//

import Foundation

import Foundation
import XCTest
import Quick
import Nimble
import RxSwift

@testable import KabuKit

class RxSwiftSpec: QuickSpec {
    
    class ActionActivatorSpeceScene: ActionScene {
        typealias RouterType = MockRouter
        typealias ContextType = Void
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        var isRemovable: Bool {
            return true
        }
        
        func willRemove(from stage: NSObject) {
            
        }
        
    }
    
    final class NotRecoverAction: Action {
        
        typealias SceneType = ActionActivatorSpeceScene
        
        public func invoke(director: Director<MockDestination>) -> [ActionEvent] {
            return []
        }
        
        func onStop() {
            
        }
        
        func onError(error: Error, label: String?) -> RecoverPattern {

            return RecoverPattern.doNothing
        }
    }
    
    final class RecoverAction: Action {
        
        typealias SceneType = ActionActivatorSpeceScene
        
        public func invoke(director: Director<MockDestination>) -> [ActionEvent] {
            return []
        }
        
        func onStop() {
            
        }
        
        func onError(error: Error, label: String?) -> RecoverPattern {
            return RecoverPattern.reloadErrorSignal(onStart: { })
        }
    }
    
    struct SampleError: Error{}
    
    override func spec() {
        
        describe("Event中の実行について") {
                        
            context("エラーが起きたら") {
                it("EventがDisposeされてハンドリングされる") {
                    let event = Observable.just(120).map({ (num) in
                        throw SampleError()
                    }).toEvent
                    let action = NotRecoverAction()
                    var isCalled = false;
                    event.start(action: action, recoverHandler: { (error, pattern) in
                        isCalled = true
                    })
                    expect(isCalled).to(beTrue())
                }
                
                it("エラーを起こしたシグナルに名前が付いていればその名前が取得が出来る") {
                    let namedActionEvent = Observable.just(120).map({ (num) in
                        throw SampleError()
                    })["named"]
                    
                    let action = NotRecoverAction()
                    
                    namedActionEvent.start(action: action, recoverHandler: { (error, pattern) in
                        expect(namedActionEvent.label).to(equal("named"))
                    })
                }
                
                
                it("Errorハンドリングの結果が取得出来る"){
                    let namedActionEvent1 = Observable.just(120).map({ (num) in
                        throw SampleError()
                    })["named1"]
                    
                    let action1 = RecoverAction()
                    
                    namedActionEvent1.start(action: action1, recoverHandler: { (error, pattern) in
                        switch pattern {
                        case .reloadErrorSignal( _):
                            break;
                        default:
                            fail()
                        }

                    })
                    
                    let namedActionEvent2 = Observable.just(120).map({ (num) in
                        throw SampleError()
                    })["named2"]
                    
                    let action2 = NotRecoverAction()
                    
                    namedActionEvent2.start(action: action2, recoverHandler: { (error, pattern) in
                        switch pattern {
                        case .doNothing:
                            break;
                        default:
                            fail()
                        }

                    })

                }
            }
            
            context("Event中にエラーがなければ") {
                it("SignalはDisposeされない") {
                    let event = Observable.just(120).toEvent
                    let action = NotRecoverAction()
                    var isCalled = false;

                    event.start(action: action, recoverHandler: { (error, pattern) in
                        isCalled = true
                    })
                    expect(isCalled).to(beFalse())
                    expect(event.isRunning).to(beTrue())
                }
                
            }
        }
    }
}
