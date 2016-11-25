//
//  Sample2Scenario.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit

class Sample2Scenario: UITabBarController, UITabBarControllerDelegate, Scenario {
    
    let aStage: UIViewController = UIViewController()
    
    let bStage: UIViewController = UIViewController()
    
    weak var root: UIViewController?
    
    func handleContext<T>(context: T) {
        let sequence = SceneSequence(aStage)
        let aName = "Sample2AViewController"
        
        root?.addChildViewController(self)
        root?.view.addSubview(self.view)
        sequence.start(ViewControllerXIBFile(aName, Bundle.main), Sample2AViewController.self, false) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let sequence = SceneSequence(bStage)
        let aName = "Sample2BViewController"
        sequence.start(ViewControllerXIBFile(aName, Bundle.main), Sample2BViewController.self, false) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
        }

    }
    
    func start(root: UIViewController) {
        aStage.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: 1)
        bStage.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 2)
        self.setViewControllers([aStage, bStage], animated: false)
        self.delegate = self
        self.selectedIndex = 0
        self.root = root
        let sequence = SceneSequence(root, self)
        let name = "Sample2ViewController"
        sequence.start(ViewControllerXIBFile(name, Bundle.main), Sample2ViewController.self) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
        }
    }
    
}
