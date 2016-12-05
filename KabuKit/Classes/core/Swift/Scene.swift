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
    
    var isRemovable: Bool { get }
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    func onRemove(stage: TransitionType.StageType)
}

extension SceneBase where Self: Scene {
   
    public func setup<S, C>(sequence:AnyObject, stage: S, argument: C, manager: SceneManager, scenario: Scenario?) {
        guard let stageType = stage as? TransitionType.StageType else {
            assert(false, "cannot setup scene")
        }

        let director = SceneDirector<TransitionType>(sequence, stageType, self, manager, scenario)
        manager.set(scene: self, stuff: (director, argument) as AnyObject)
    }
    
    public func clear<S>(stage: S, manager: SceneManager) {
        guard let stageType = stage as? TransitionType.StageType else {
            assert(false, "cannot clear scene")
        }
        if (isRemovable) {
            onRemove(stage: stageType)
            manager.release(scene: self)
        }
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
        guard let sceneContents = manager.getStuff(scene: self) as? (SceneDirector<TransitionType>, ArgumentType?) else {
            assert(false, "Illegal Operation Error")
        }

        return sceneContents.0
    }
    

    public var argument: ArgumentType? {
        guard let manager = SceneManager.managerByScene(scene: self) else {
            return nil
        }
        guard let sceneContents = manager.getStuff(scene: self) as? (SceneDirector<TransitionType>, ArgumentType?) else {
            assert(false, "Illegal Operation Error")
        }
        
        return sceneContents.1
    }

}
