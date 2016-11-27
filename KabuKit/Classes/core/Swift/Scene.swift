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
     このメソッドが呼ばれた段階で遷移するわけではなく、このメソッドが返すSceneRequestが実行されたタイミングで画面遷移を行います
     
     - Parameter link: どのSceneへリンクするかの指定です。このlinkをみてこのメソッドないでハンドリングすることになります
     - Parameter factory: SceneRequestを生成するFactoryです
     - Returns: SceneRequest
     */
    func onChangeSceneRequest(link: LinkType, factory: SceneRequestFactory<StageType>) -> SceneRequest?
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: Bool 
     */
    func onBackRequest(factory: SceneBackRequestFactory<StageType>) -> SceneBackRequest?
}

extension Frame where Self: Scene {

    public func back<S: AnyObject>(stage: S) -> SceneBackRequest? {
        let factory = SceneBackRequestFactory(stage: stage as! StageType)
        return onBackRequest(factory: factory)
    }

    public func setup<S: AnyObject>(stage: S, container: FrameContainer, scenario: Scenario?) {
        let transition = SceneTransition<Self.LinkType>(stage, self, container, scenario)
        set(transition: transition)
    }
    
    public func transit(link: SceneLink, stage: AnyObject, frames: FrameContainer, scenario: Scenario?) -> SceneRequest? {
        let link2 = link as! Self.LinkType
        let stage2 = stage as! Self.StageType
        let sceneFactory = SceneRequestFactory<Self.StageType>(stage2, frames, scenario)
        return onChangeSceneRequest(link: link2, factory: sceneFactory)
    }

}

extension Scene {
    
    public unowned var transition: SceneTransition<LinkType> {
        return FrameStore.transitions.object(forKey: self as AnyObject) as! SceneTransition<LinkType>
    }
    
    public var context: ContextType? {
        return FrameStore.contexts.object(forKey: self as AnyObject) as? ContextType
    }

}
