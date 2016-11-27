//
//  Sample1BScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1BViewController : ActionScene {
    
    enum Sample1BLink : SceneLink {
        case A
        case B
    }
    
    typealias StageType = UIViewController
    typealias ContextType = Void
    typealias LinkType = Sample1BLink
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample1BAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: self.transition, context: self.context)
    }
    
    func onChangeSceneRequest(link: Sample1BLink, factory: SceneChangeRequestFactory<UIViewController>) -> SceneChangeRequest? {

        switch link {
        case .A:
            let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
            let vc = factory.createSceneChangeRequest(xib, Sample1AViewController.self, true) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        case .B:
            let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
            let vc = factory.createSceneChangeRequest(xib, Sample1BViewController.self, nil) { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            }
            return vc
        }
    }
    
    func onBackRequest(factory: SceneBackRequestFactory<UIViewController>) -> SceneBackRequest? {
        return factory.createBackRequest({ (stage) -> Bool in
            _ = stage.navigationController?.popViewController(animated: true)
            return true
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil) {
            end()
        }
    }
    
}
