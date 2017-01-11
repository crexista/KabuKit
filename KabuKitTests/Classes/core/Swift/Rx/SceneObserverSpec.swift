//
//  Copyright © 2017年 crexista
//

import Foundation
import RxSwift
import XCTest
import Quick
import Nimble

@testable import KabuKit

class SceneObserverSpec: QuickSpec {
    
    class MockAction: Action2 {
        
        typealias DestinationType = MockDestination

        public func invoke(director: Director<MockDestination>) -> [ObserverTarget] {
            return []
        }

        func onStop() {

        }
        

        func onError(error: Error, label: String?) -> ActionRecoverPattern {
            return ActionRecoverPattern.doNothing
        }
    }
    
    class SceneObserverSpeceScene: ActionScene2 {
        typealias RouterType = MockRouter
        typealias ArgumentType = Void
        
        public var router: MockRouter {
            return MockRouter()
        }
        
        var isRemovable: Bool {
            return true
        }
        
        func onRemove(stage: NSObject) {

        }
        
    }
    
    override func spec() {
        
        describe("Actionを取得の仕方") {
            context("指定のActionがすでにActivate済みの場合") {
                it("observerのresolveによって取得することができる") {
                    let scene = SceneObserverSpeceScene()
                    let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)

                    let observer = SceneObserver2(director: director)
                    let action = MockAction()

                    _ = observer.activate(action: action)
                    let resolvedAction = observer.resolve(actionType: MockAction.self)
                    expect(resolvedAction) === action
                }
            }
            
            context("指定のActionがまだActivateされていない場合") {
                
                it("observerのresolveを使っても取得できない") {
                    let scene = SceneObserverSpeceScene()
                    let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let observer = SceneObserver2(director: director)

                    let resolvedAction = observer.resolve(actionType: MockAction.self)
                    expect(resolvedAction).to(beNil())
                }
            }
        }
        
        describe("ActionのActivateは") {
            let action = MockAction()

            context("activateされるactionがまだ未登録の場合") {
               
                it("activateが成功する") {
                    let scene = SceneObserverSpeceScene()
                    let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let observer = SceneObserver2(director: director)

                    let result = observer.activate(action: action)
                    let resolvedAction = observer.resolve(actionType: MockAction.self)
                    expect(result).to(beTrue())
                    expect(resolvedAction) === action
                }
            }
            

            context("activateされるactionがすでに登録済みの場合") {
                let scene = SceneObserverSpeceScene()
                let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                
                let observer = SceneObserver2(director: director)

                _ = observer.activate(action: action)
                it("activateは再度実行されることはない") {
                    let result = observer.activate(action: action)
                    let resolvedAction = observer.resolve(actionType: MockAction.self)
                    expect(result) === false
                    expect(resolvedAction) === action
                }
            }
            context("activateされるactionと同じクラスの別インスタンスがすでに登録済みの場合") {
                let scene = SceneObserverSpeceScene()
                let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                let director = Director(scene: scene, sequence: sequence)
                
                let observer = SceneObserver2(director: director)

                _ = observer.activate(action: action)
                it("activateはエラーを返す") {
                    let action2 = MockAction()
                    _ = observer.activate(action: action2)
                }
            }

        }
        
        describe("Actionのdeactivateは") {
            let action = MockAction()

            context("deactivateされるactionがまだ未登録の場合") {
                it("何も起こらない") {

                    let scene = SceneObserverSpeceScene()
                    let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let observer = SceneObserver2(director: director)

                    let result = observer.deactivate(actionType: type(of: action))
                    let resolvedAction = observer.resolve(actionType: MockAction.self)
                    expect(result) === false
                    expect(resolvedAction).to(beNil())
                }
            }
            context("deactivateされるactionが登録済みである場合"){
                it("actionがサスペンドされ、actionに紐づくSignalは削除される") {
                    let scene = SceneObserverSpeceScene()
                    let sequence = SceneSequence2(NSObject(), scene, nil){ (stage, scene) in }
                    let director = Director(scene: scene, sequence: sequence)
                    
                    let observer = SceneObserver2(director: director)
                    
                    _ = observer.activate(action: action)
                    expect(observer.isActive(actionType: MockAction.self)) === true
                    let result = observer.deactivate(actionType: MockAction.self)
                    expect(result) === true
                    expect(observer.isActive(actionType: MockAction.self)) === false
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
