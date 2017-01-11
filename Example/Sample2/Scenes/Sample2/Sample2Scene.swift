//
//  Sample2Scene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2ViewController: ActionScene {
    
    enum Sample2Link: SceneTransition {

        typealias StageType = UIViewController
        case A
        
        public func request(context: SceneContext<UIViewController>) -> SceneRequest? {
            return context.sequenceRequest({ () -> AnyObject in
                return "Main" as AnyObject
            })
        }
        
    }
    
    typealias ContextType = Void
    typealias TransitionType = Sample2Link

    override func viewDidLoad() {
        let action = Sample2Action(startButton: startButton)
        activator.activate(action: action, director: director, context: context)
    }
    
    public var isRemovable: Bool {
        return false
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
