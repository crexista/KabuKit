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
    
    enum Sample1BLink : Link {
        case A
        case B
    }
    
    typealias stageType = UIViewController
    typealias contextType = Void
    typealias linkType = Sample1BLink
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample1BAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: self.transition, context: self.context)
    }
    
    func onSceneTransitionRequest(container: UIViewController, link: Sample1BViewController.Sample1BLink, maker: Maker, scenario: Scenario?) -> Frame? {
        let aName : String = "Sample1AViewController"
        let bName : String = "Sample1BViewController"
        switch link {
        case .A:
            let vc = maker.make(ViewControllerXIBFile(aName, Bundle.main), Sample1AViewController.self, true)
            container.navigationController?.pushViewController(vc, animated: true)
            
            return vc
        case .B:
            let vc = maker.make(ViewControllerXIBFile(bName, Bundle.main), Sample1BViewController.self, nil)
            container.navigationController?.pushViewController(vc, animated: true)
            return vc
        }
    }
    
    func onBackRequest(container: UIViewController) {
        _ = container.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil) {
//            transition.back()
        }
    }
    
}
