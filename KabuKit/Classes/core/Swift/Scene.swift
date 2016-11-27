//
//  Scene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/14.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Scene : Frame {
    
    associatedtype Link: SceneLink
    
    associatedtype Context
    
    associatedtype Stage: AnyObject
    
    var context: Context? { get }
    
    unowned var transition: SceneTransition<Link> { get }
    
    /**
     違うSceneへの遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが呼ばれた段階で遷移するわけではなく、このメソッドが返すSceneRequestが実行されたタイミングで画面遷移を行います
     
     - Parameter link: どのSceneへリンクするかの指定です。このlinkをみてこのメソッドないでハンドリングすることになります
     - Parameter factory: SceneRequestを生成するFactoryです
     - Returns: SceneRequest
     */
    func onChangeSceneRequest(link: Link, factory: SceneRequestFactory<Stage>) -> SceneRequest?
    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: Bool 
     */
    func onBackRequest(factory: SceneBackRequestFactory<Stage>) -> SceneBackRequest?
}

extension Frame where Self: Scene {

    public func back<S: AnyObject>(stage: S) -> SceneBackRequest? {
        let factory = SceneBackRequestFactory(stage: stage as! Stage)
        return onBackRequest(factory: factory)
    }

    public func setup<S: AnyObject>(stage: S, container: FrameContainer, scenario: Scenario?) {
        let transition = SceneTransition<Self.Link>(stage, self, container, scenario)
        set(transition: transition)
    }
    
    public func transit(link: SceneLink, stage: AnyObject, frames: FrameContainer, scenario: Scenario?) -> SceneRequest? {
        let link2 = link as! Self.Link
        let stage2 = stage as! Self.Stage
        let sceneFactory = SceneRequestFactory<Self.Stage>(stage2, frames, scenario)
        return onChangeSceneRequest(link: link2, factory: sceneFactory)
    }

}

extension Scene {
    
    public unowned var transition: SceneTransition<Link> {
        return FrameStore.transitions.object(forKey: self as AnyObject) as! SceneTransition<Link>
    }
    
    public var context: Context? {
        return FrameStore.contexts.object(forKey: self as AnyObject) as? Context
    }

}
