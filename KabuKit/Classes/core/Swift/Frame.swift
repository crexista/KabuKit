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
    
    func setup<S: AnyObject, C>(stage: S, context: C, container: FrameManager, scenario: Scenario?)
    
    func transit(link: SceneLink, stage: AnyObject, frames: FrameManager, scenario: Scenario?) -> SceneChangeRequest?

}

public class FrameManager {
    
    // key: Scene
    private static var managers: NSMapTable<AnyObject, FrameManager> = NSMapTable.weakToWeakObjects()
    
    // key: Scene, value: (transition, context) のタプルか (transition, context, actor) のタプル
    private var frameHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    /**
     FrameManagerで管理されているSceneを解放し、内部で保持されているTransitionやContextへの参照を外します
     
     */
    internal func release(frame: Frame) {
        FrameManager.managers.removeObject(forKey: frame)
        frameHashMap.removeObject(forKey: frame)
    }
    
    internal func set(frame: Frame, stuff: AnyObject) {
        frameHashMap.setObject(stuff, forKey: frame)
        FrameManager.managers.setObject(self, forKey: frame)
    }
    
    internal func getStuff(frame: Frame) -> AnyObject? {
        return frameHashMap.object(forKey: frame)
    }
    
    internal static func managerByScene<S: Scene>(scene: S) -> FrameManager? {
        return FrameManager.managers.object(forKey: scene)
    }
    
    /**
     このライブラリ外からinstance化させないため、コンストラクタをinternal化

     */
    internal init (){}
}
