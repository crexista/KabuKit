//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scene : Frame {
    
    associatedtype LinkType: SceneLink
    
    associatedtype ContextType
    
    associatedtype StageType: AnyObject
    
    var context: ContextType? { get }
    
    unowned var transition: SceneTransition<LinkType> { get }
    
    /**
     違うSceneへの遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが呼ばれた段階で遷移するわけではなく、このメソッドが返すSceneChangeRequestが実行されたタイミングで画面遷移を行います
     
     - Parameter link: どのSceneへリンクするかの指定です。このlinkをみてこのメソッドないでハンドリングすることになります
     - Parameter factory: SceneChangeRequestを生成するFactoryです
     - Returns: SceneChangeRequest
     */
    func onChangeSceneRequest(link: LinkType, factory: SceneChangeRequestFactory<StageType>) -> SceneChangeRequest?
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    func onBackRequest(factory: SceneBackRequestFactory<StageType>) -> SceneBackRequest?
    
    
    /**
     このメソッドを呼ぶと画面に紐づけられたtransitionやcontext(ActionSceneの場合はActorも)が解放されます
     ただし、メモリ解放をするだけであり別に表示そのものが変わるというわけではありません
     表示の変更に関しては実装する必要があります
     
     */
    func release()
}

extension Frame where Self: Scene {

    public func back<S: AnyObject>(stage: S) -> SceneBackRequest? {
        let factory = SceneBackRequestFactory(stage: stage as! StageType)
        return onBackRequest(factory: factory)
    }
   
    public func setup<S: AnyObject, C>(stage: S, context: C, container: FrameManager, scenario: Scenario?) {
        let transition = SceneTransition<Self.LinkType>(stage, self, container, scenario)
        container.set(frame: self, stuff: (transition, context) as AnyObject)
    }
    
    public func transit(link: SceneLink, stage: AnyObject, frames: FrameManager, scenario: Scenario?) -> SceneChangeRequest? {
        let link2 = link as! Self.LinkType
        let stage2 = stage as! Self.StageType
        let sceneFactory = SceneChangeRequestFactory<Self.StageType>(stage2, frames, scenario)
        return onChangeSceneRequest(link: link2, factory: sceneFactory)
    }

}

extension Scene {
    
    public unowned var transition: SceneTransition<LinkType> {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneTransition<LinkType>, ContextType?)
        return result.0
    }
    
    public var context: ContextType? {
        let manager = FrameManager.managerByScene(scene: self)!
        let result = manager.getStuff(frame: self) as! (SceneTransition<LinkType>, ContextType?)
        return result.1
    }
    
    public func release() {
        if let manager = FrameManager.managerByScene(scene: self) {
            manager.release(frame: self)
        }        
    }

}
