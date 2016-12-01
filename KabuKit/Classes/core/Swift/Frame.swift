//
//  BaseScene.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © crexista. All rights reserved.
//

import Foundation

/**
 TODO 後でScreenという名前に変更する
 
 */
public protocol BaseScene : class {
    
    /**
     画面表示をセットアップします
     
     */
    func setup<S, C>(sequence:AnyObject, stage: S, argument: C, container: SceneManager, scenario: Scenario?)
    
    /**
     画面表示周りを破棄します
     
     - returns: Bool
       - true 表示のクリアに成功
       - false 表示のクリアに失敗
     */
    func clear<S>(stage: S) -> Bool
}

public class SceneManager {
    
    // key: Scene
    private static var managers: NSMapTable<AnyObject, SceneManager> = NSMapTable.weakToWeakObjects()
    
    // key: Scene, value: (director, argument) のタプルか (director, argument, actor) のタプル
    private var frameHashMap: NSMapTable<AnyObject, AnyObject> = NSMapTable.strongToStrongObjects()
    
    /**
     SceneManagerで管理されているSceneを解放し、内部で保持されているdirectorやContextへの参照を外します
     
     */
    internal func release(frame: BaseScene) {
        SceneManager.managers.removeObject(forKey: frame)
        frameHashMap.removeObject(forKey: frame)
    }
    
    internal func set(frame: BaseScene, stuff: AnyObject) {
        frameHashMap.setObject(stuff, forKey: frame)
        SceneManager.managers.setObject(self, forKey: frame)
    }
    
    internal func getStuff(frame: BaseScene) -> AnyObject? {
        return frameHashMap.object(forKey: frame)
    }
    
    internal static func managerByScene<S: Scene>(scene: S) -> SceneManager? {
        return SceneManager.managers.object(forKey: scene)
    }
    
    /**
     このライブラリ外からinstance化させないため、コンストラクタをinternal化

     */
    internal init (){}
}
