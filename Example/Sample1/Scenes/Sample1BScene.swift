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
    
    enum Sample1Link : Link {
        case A
        case B
    }
    
    typealias stageType = UIViewController
    typealias contextType = Void
    typealias linkType = Sample1Link
    
    override func viewDidLoad() {
        
    }
    
    func onSceneTransitionRequest(container: UIViewController, link: Sample1BViewController.Sample1Link, maker: Maker, scenario: Scenario?) -> Frame? {
        return nil
    }
    
    func onBackRequest(container: UIViewController) {
        
    }
    
}
