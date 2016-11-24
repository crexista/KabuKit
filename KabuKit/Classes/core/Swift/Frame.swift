//
//  Frame.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation

public protocol Frame {

    func back(stage: AnyObject)
    
    func setup(stage: AnyObject, container: FrameContainer, scenario: Scenario?)
    
    func transit<T: Link>(link: T, maker: Maker) -> Frame?
    
    func close()

}

internal class FrameStore {
    static var transitions: NSMapTable<AnyObject, AnyObject> = NSMapTable.weakToStrongObjects()
    static var contexts: NSMapTable<AnyObject, AnyObject> = NSMapTable.weakToStrongObjects()
    static var actors: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
}

public class FrameContainer {
    
    internal var frames: [Frame] = [Frame]()
}

extension Frame {
    
    func set<linkType: Link>(transition: SceneTransition<linkType>) {
        FrameStore.transitions.setObject(transition, forKey: self as AnyObject)
    }
    
    func set<contextType>(context: contextType?) {
        FrameStore.contexts.setObject(context as AnyObject?, forKey: self as AnyObject)
    }
    
    func set(actor: Actor) {
        FrameStore.actors.setObject(actor, forKey: self as AnyObject)
    }
    
    public func close() {
        FrameStore.transitions.removeObject(forKey: self as AnyObject)
        FrameStore.contexts.removeObject(forKey: self as AnyObject)
    }
}

