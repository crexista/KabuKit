//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © crexista. All rights reserved.
//

import Foundation

public protocol Scene : SceneBase {
    
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

extension SceneBase where Self: Scene {
   
    public func setup<S, C>(guard: SceneBaseGuard, sequence:AnyObject, stage: S, argument: C, manager: SceneManager, scenario: Scenario?) {
        guard let stageType = stage as? TransitionType.StageType else {
            assert(false, "cannot setup scene")
        }

        let director = DefaultSceneDirector<TransitionType>(sequence, stageType, self, manager, scenario)
        manager.set(frame: self, stuff: (director, argument) as AnyObject)
    }
    
    public func clear<S>(guard: SceneBaseGuard, stage: S) -> Bool {
        guard let stageType = stage as? TransitionType.StageType else {
            assert(false, "cannot clear scene")
        }
        return onRelease(stage: stageType)
    }
}

extension Scene {
    
    public var isReleased: Bool {
        return SceneManager.managerByScene(scene: self) == nil
    }
    
    public weak var director: SceneDirector<TransitionType>? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(frame: self) as? (DefaultSceneDirector<TransitionType>, ArgumentType?) else {
            assert(false, "Illegal Operation Error")
        }

        return sceneContents.0
    }
    

    public var argument: ArgumentType? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(frame: self) as? (DefaultSceneDirector<TransitionType>, ArgumentType?) else {
            assert(false, "Illegal Operation Error")
        }
        
        return sceneContents.1
    }

}
