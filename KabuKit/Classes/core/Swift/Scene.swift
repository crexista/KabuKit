//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol Scene : BaseScene {
    
    associatedtype TransitionType: SceneTransition
    
    associatedtype ArgumentType
    
    var argument: ArgumentType? { get }
    
    weak var director: SceneDirector<TransitionType>? { get }
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    func onRelease(stage: TransitionType.StageType) -> Bool
}

extension BaseScene where Self: Scene {
   
    public func setup<S, C>(sequence:AnyObject, stage: S, argument: C, container: SceneManager, scenario: Scenario?) {
        let director = DefaultSceneDirector<TransitionType>(sequence, stage as! TransitionType.StageType, self, container, scenario)
        container.set(frame: self, stuff: (director, argument) as AnyObject)
    }
    
    public func clear<S>(stage: S) -> Bool {
        return onRelease(stage: stage as! TransitionType.StageType)
    }
}

extension Scene {
    
    public var isReleased: Bool {
        return SceneManager.managerByScene(scene: self) == nil
    }
    
    public weak var director: SceneDirector<TransitionType>? {
        if let manager = SceneManager.managerByScene(scene: self) {
            let result = manager.getStuff(frame: self) as! (DefaultSceneDirector<TransitionType>, ArgumentType?)
            return result.0
        } else {
            return SceneDirector<TransitionType>()
        }
    }
    

    public var argument: ArgumentType? {
        let manager = SceneManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (DefaultSceneDirector<TransitionType>, ArgumentType?)
        return result.1
    }

}
