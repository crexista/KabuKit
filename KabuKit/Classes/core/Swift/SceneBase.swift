//
//  SceneBase.swift
//  KabuKit
//
//  Created by crexista on 2016/11/17.
//  Copyright © crexista. All rights reserved.
//

import Foundation

/**
 Sceneの基底となるProtocolです。
 このProtocolそのものを指定して使う事は基本的にはしないでください
 
 */
public protocol SceneBase : class {
    
    /**
     画面表示をセットアップします
     
     ## IMPORTANT ##
     このメソッドは呼び出さないでください
     
     */
    func setup<S, C>(sequence:AnyObject, stage: S, argument: C, manager: SceneManager, scenario: Scenario?)
    
    /**
     画面表示周りを破棄します
     
     ## IMPORTANT ##
     このメソッドは呼び出さないでください

     */
    func clear<S>(stage: S, manager: SceneManager)
}
