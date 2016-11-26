//
//  Sample2AScene.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample2AViewController: ActionScene {
    
    enum Sample2Link: Link {
        case A
        case B
    }
    
    typealias stageType = UIViewController
    typealias contextType = Bool
    typealias linkType = Sample2Link
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        let action = Sample2AAction(nextButtonA: nextButtonA, nextButtonB: nextButtonB, prevButton: prevButton)
        actor.activate(action: action, transition: transition, context: context)
    }
    
    func onSceneTransitionRequest(container: UIViewController, link: Sample2AViewController.Sample2Link, maker: Maker, scenario: Scenario?) -> Frame? {

        let aName : String = "Sample2AViewController"
        let bName : String = "Sample2BViewController"
        print(container.navigationController)
        switch link {
        case .A:
            let vc = maker.make(ViewControllerXIBFile(aName, Bundle.main), Sample2AViewController.self, true)
            container.navigationController?.pushViewController(vc, animated: true)
            
            return vc
        case .B:
            let vc = maker.make(ViewControllerXIBFile(bName, Bundle.main), Sample2BViewController.self, true)
            container.navigationController?.pushViewController(vc, animated: true)
            return vc
        }
    }
    
    func onBackRequest(container: UIViewController) {
        _ = container.navigationController?.popViewController(animated: true)
    }
}
