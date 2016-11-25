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
    
    enum Sample2Link: Link {
        case A
    }
    
    typealias stageType = UIViewController
    typealias contextType = Bool
    typealias linkType = Sample2Link
    
    func onSceneTransitionRequest(container: UIViewController, link: Sample2BViewController.Sample2Link, maker: Maker, scenario: Scenario?) -> Frame? {
        return nil
    }
    
    func onBackRequest(container: UIViewController) {
        
    }
}
