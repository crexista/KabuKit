//
//  Sample2AScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2AViewController: ActionScene {
    
    typealias ContextType = Bool
    typealias TransitionType = Sample2Link
    
    enum Sample2Link: SceneTransition {
        typealias StageType = UIViewController
        case A
        case B
        
        func request(context: SceneContext<UIViewController>) -> SceneRequest? {
            
            switch self {
            case .A:
                let File2A = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
                return context.sceneRequest(File2A, Sample2AViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }

            case .B:
                let File2B = ViewControllerXIBFile("Sample2BViewController", Bundle.main)
                return context.sceneRequest(File2B, Sample2BViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            }
        }
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
        _ = stage.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample2AAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        activator.activate(action: action, director: director, context: context)
    }

}
