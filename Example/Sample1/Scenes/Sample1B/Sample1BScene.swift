//
//  Sample1BScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit


extension Sample1BViewController : ActionScene, SceneLinkage {
    
    enum Sample2Destination: Destination {
        typealias StageType = UIViewController
        case a
        case b
    }
    
    typealias DestinationType = Sample2Destination
    
    typealias ContextType = Void
    
    func guide(to destination: Sample2Destination) -> SceneTransition<UIViewController>? {
        
        switch destination {
        case .a:
            let newScene = Sample1AViewController(nibName: "Sample1AViewController", bundle: Bundle.main)
            return destination.specify(newScene, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            
        case .b:
            let newScene = Sample1BViewController(nibName: "Sample1BViewController", bundle: Bundle.main)
            return destination.specify(newScene, nil) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            
        }
    }
        
    func willRemove(from stage: UIViewController) {
        _ = stage.navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample1BAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        _ = activator?.activate(action: action)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil) {
            //_ = director?.back()
        }
    }
    
}

