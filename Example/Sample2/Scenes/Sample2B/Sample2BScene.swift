//
//  Sample2BScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2BViewController: ActionScene {
    
    enum Sample2Link: SceneLink {
        case A
        case B
    }
    
    typealias StageType = UIViewController
    typealias ContextType = Bool
    typealias LinkType = Sample2Link
    
    override func viewDidLoad() {
        let action = Sample2BAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: transition, context: context)
    }

    func onChangeSceneRequest(link: Sample2Link, factory: SceneChangeRequestFactory<UIViewController>) -> SceneChangeRequest? {
        var request: SceneChangeRequest?
        
        switch link {
        case .A:
            let File2A = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
            request = factory.createSceneChangeRequest(File2A, Sample2AViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            break;
        case .B:
            let File2B = ViewControllerXIBFile("Sample2BViewController", Bundle.main)
            request = factory.createSceneChangeRequest(File2B, Sample2BViewController.self, true) { (stage, scene) in

                stage.navigationController?.pushViewController(scene, animated: true)
            }
        }
        
        return request
    }

    func onBackRequest(factory: SceneBackRequestFactory<UIViewController>) -> SceneBackRequest? {
        return factory.createBackRequest({ (stage) -> Bool in
            _ = stage.navigationController?.popViewController(animated: true)
            return true
        })
    }
}
