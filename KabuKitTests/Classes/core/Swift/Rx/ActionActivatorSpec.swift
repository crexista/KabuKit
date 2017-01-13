//
//  Copyright © 2017 crexista
//

import Foundation
import RxSwift
import XCTest
import Quick
import Nimble

@testable import KabuKit

class ActionActivatorSpec: QuickSpec {
    
    final class MockAction: Action {
        
        typealias SceneType = ActionActivatorSpeceScene

        public func invoke(director: Director<MockDestination>) -> [ActionEvent] {
            return []
        }

        func onStop() {

        }
        
        func onError(error: ActionError<ActionActivatorSpec.MockAction>) -> RecoverPattern {

            return RecoverPattern.doNothing
        }
    }
    
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
    
    override func spec() {
        
        describe("Actionを取得の仕方") {
            context("指定のActionがすでにActivate済みの場合") {
                it("activatorのresolveによって取得することができる") {
                    let scene = ActionActivatorSpeceScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)

                    let activator = ActionActivator(director: director)
                    let action = MockAction()

                    _ = activator.activate(action: action)
                    let resolvedAction = activator.resolve(actionType: MockAction.self)
                    expect(resolvedAction) === action
                }
            }
            
            context("指定のActionがまだActivateされていない場合") {
                
                it("activatorのresolveを使っても取得できない") {
                    let scene = ActionActivatorSpeceScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }

                    let director = Director(scene: scene, sequence: sequence)
                    
                    let activator = ActionActivator(director: director)

                    let resolvedAction = activator.resolve(actionType: MockAction.self)
                    expect(resolvedAction).to(beNil())
                }
            }
        }
        
        describe("ActionのActivateは") {
            let action = MockAction()

            context("activateされるactionがまだ未登録の場合") {
               
                it("activateが成功する") {
                    let scene = ActionActivatorSpeceScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let activator = ActionActivator(director: director)

                    let result = activator.activate(action: action)
                    let resolvedAction = activator.resolve(actionType: MockAction.self)
                    expect(result).to(beTrue())
                    expect(resolvedAction) === action
                }
            }
            

            context("activateされるactionがすでに登録済みの場合") {
                let scene = ActionActivatorSpeceScene()
                let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                
                let activator = ActionActivator(director: director)

                _ = activator.activate(action: action)
                it("activateは再度実行されることはない") {
                    let result = activator.activate(action: action)
                    let resolvedAction = activator.resolve(actionType: MockAction.self)
                    expect(result) === false
                    expect(resolvedAction) === action
                }
            }
            context("activateされるactionと同じクラスの別インスタンスがすでに登録済みの場合") {
                let scene = ActionActivatorSpeceScene()
                let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }

                let director = Director(scene: scene, sequence: sequence)
                
                let activator = ActionActivator(director: director)

                _ = activator.activate(action: action)
                it("activateはエラーを返す") {
                    let Action = MockAction()
                    _ = activator.activate(action: Action)
                }
            }

        }
        
        describe("Actionのdeactivateは") {
            let action = MockAction()

            context("deactivateされるactionがまだ未登録の場合") {
                it("何も起こらない") {

                    let scene = ActionActivatorSpeceScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }

                    let director = Director(scene: scene, sequence: sequence)
                    
                    let activator = ActionActivator(director: director)

                    let result = activator.deactivate(actionType: type(of: action))
                    let resolvedAction = activator.resolve(actionType: MockAction.self)
                    expect(result) === false
                    expect(resolvedAction).to(beNil())
                }
            }
            context("deactivateされるactionが登録済みである場合"){
                it("actionがサスペンドされ、actionに紐づくSignalは削除される") {
                    let scene = ActionActivatorSpeceScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let activator = ActionActivator(director: director)
                    
                    _ = activator.activate(action: action)
                    expect(activator.isActive(actionType: MockAction.self)) === true
                    let result = activator.deactivate(actionType: MockAction.self)
                    expect(result) === true
                    expect(activator.isActive(actionType: MockAction.self)) === false
                }
            }

        }
        
        describe("監視しているAction内で起きたエラーのハンドリングについて") {
            context("Targetにラベルを振っている場合は") {
                it("actionのonErrorにストリームのラベル情報が入ってくる") {
                    //TODO 実装
                }
            }
            context("Targetにラベルを振ってい無い場合は") {
                it("actionのonErrorにストリームのラベル情報は入ってこない") {
                    //TODO 実装
                }
            }
            
            context("エラーハンドラで返したリカバーの種類が何もしないであった場合") {
                it("何も起きない"){
                    //TODO 実装
                }
            }
            
            context("エラーハンドラで返したリカバーの種類がactionの再読み込みだった場合") {
                it("actionが再読み込みされる"){
                    //TODO 実装
                }
                it("actionの再読み込み時に指定したコールバックが呼ばれる") {
                    //TODO 実装
                }
            }
            
            context("エラーハンドラで返したリカバーの種類がエラーを起こしたObservableのみの再読み込みだった場合") {
                it("actionは再読み込みされず、指定のObservableのみ再度subscribeされる"){
                    //TODO 実装
                }
                it("指定したコールバックが呼ばれる") {
                    //TODO 実装
                }
            }


        }
    }
}
