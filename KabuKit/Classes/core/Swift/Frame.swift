//
//  Frame.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Frame : class {

    func back<S: AnyObject>(stage: S) -> SceneBackRequest?
    
    func setup<S: AnyObject>(stage: S, container: FrameContainer, scenario: Scenario?)
    
    func transit(link: SceneLink, stage: AnyObject, frames: FrameContainer, scenario: Scenario?) -> SceneChangeRequest?
    
    /**
     このフレームワークによって現在表示中の画面に紐づけられた全てのインスタンスを終了させます
     インスタンスを終了させるだけであるため、別に表示そのものが変わるというわけではありません
     表示の変更に関しては実装する必要があります
     
     */
    func end()

}

internal class FrameStore {
    static var transitions: NSMapTable<AnyObject, AnyObject> = NSMapTable.weakToStrongObjects()
    static var contexts: NSMapTable<AnyObject, AnyObject> = NSMapTable.weakToStrongObjects()
    static var actors: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
}

public class FrameContainer {
    
    public var frames: [Frame] = [Frame]()
}

extension Frame {
    
    func set<Link: SceneLink>(transition: SceneTransition<Link>) {
        FrameStore.transitions.setObject(transition, forKey: self as AnyObject)
    }
    
    func set<contextType>(context: contextType?) {
        FrameStore.contexts.setObject(context as AnyObject?, forKey: self as AnyObject)
    }
    
    func set(actor: Actor) {
        FrameStore.actors.setObject(actor, forKey: self as AnyObject)
    }
    
    public func end() {
        FrameStore.transitions.removeObject(forKey: self as AnyObject)
        FrameStore.contexts.removeObject(forKey: self as AnyObject)
        FrameStore.actors.removeObject(forKey: self as AnyObject)
    }
}

