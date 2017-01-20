//
//  Sample2BScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2BViewController: ActionScene, SceneLinkage {
    
    enum SampleBDestination: Destination {
        typealias StageType = UIViewController
        case a
        case b
    }
    
    typealias DestinationType = SampleBDestination
    
    typealias ContextType = Bool
    
    func guide(to destination: SampleBDestination) -> SceneTransition<UIViewController>? {
        switch destination {
        case .a:
            let vc = Sample2AViewController(nibName: "Sample2AViewController", bundle: Bundle.main)
            return destination.specify(vc, true){ (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            
        case .b:
            let vc = Sample2BViewController(nibName: "Sample2BViewController", bundle: Bundle.main)
            return destination.specify(vc, true, { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            })
        }
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
        let action = Sample2BAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        if let isEnabled = context {
            self.prevButton.isEnabled = isEnabled
            self.prevButton.alpha = 1.0
        } else {
            self.prevButton.isEnabled = false
            self.prevButton.alpha = 0.5
        }
        activator?.activate(action: action)
    }

    
}
