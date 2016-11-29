//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scene : Frame {
    
    associatedtype TransitionType: SceneTransition
    
    associatedtype ContextType
    
    var context: ContextType? { get }
    
    unowned var director: SceneDirector<TransitionType> { get }
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    func onRelease(stage: TransitionType.StageType) -> Bool
}

extension Frame where Self: Scene {
   
    public func setup<S, C>(stage: S, context: C, container: FrameManager, scenario: Scenario?) {
        let director = SceneDirector<Self.TransitionType>(stage as! TransitionType.StageType, self, container, scenario)
        container.set(frame: self, stuff: (director, context) as AnyObject)
    }
    
    public func clear<S>(stage: S) -> Bool {
        return onRelease(stage: director.stage)
    }
}

extension Scene {
    
    public var isReleased: Bool {
        return FrameManager.managerByScene(scene: self) == nil
    }
    
    public unowned var director: SceneDirector<TransitionType> {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneDirector<TransitionType>, ContextType?)
        return result.0
    }
    
    public var context: ContextType? {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneDirector<TransitionType>, ContextType?)
        return result.1
    }

}
