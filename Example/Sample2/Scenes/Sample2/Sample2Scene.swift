//
//  Sample2Scene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

//extension Sample2ViewController: ActionScene, SceneLinkage {
extension Sample2ViewController : ActionScene, SceneLinkage {
    
    enum Sample2Destination: Destination {
        typealias StageType = UIViewController
        case a
        case b
    }
    
    typealias DestinationType = Sample2Destination
    
    typealias ContextType = Void
    
    func guide(to destination: Sample2ViewController.Sample2Destination) -> SceneTransition<UIViewController>? {
        return nil
    }
    
    
    override func viewDidLoad() {
        let action = Sample2Action(startButton: startButton)
        _ = activator?.activate(action: action)
    }
    

    
    /**
     前の画面への遷移リクエストが飛んできたときに呼ばれるメソッドです
     このメソッドが返すSceneBackRequestのexecuteが呼ばれた際にtrueを返すとこの画面のに紐づくメモリが解放されます
     
     - Parameter factory: 前の画面への遷移リクエストを生成するインスタンスです
     - Returns: SceneBackRequest 前の画面への遷移リクエストが成功したらSceneBackRequestはtrueを返します
     */
    public func willRemove(from stage: UIViewController) {
    }
}
