//
//  Sample2Scene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2ViewController: ActionScene {
    
    enum Sample2Link: SceneLink {
        case A
    }
    
    typealias Stage = UIViewController
    typealias Context = Void
    typealias Link = Sample2Link
    
    override func viewDidLoad() {
        let action = Sample2Action(startButton: startButton)
        actor.activate(action: action, transition: transition, context: context)
    }
        
    func onChangeSceneRequest(link: Sample2Link, factory: SceneRequestFactory<UIViewController>) -> SceneRequest? {
        return factory.createOtherScenarioRequest { (stage, scenario) in
            scenario?.handleContext(context: "Main")
        }
    }
    
    func onBackRequest(container: UIViewController) -> Bool {
        _ = container.navigationController?.popViewController(animated: true)
        return true
    }
}
