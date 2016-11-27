//
//  Sample2Scenario.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © 2016年 crexista. All rights reserved.
//

import Foundation
import KabuKit
import UIKit

@objc class Sample2Scenario: NSObject, UITabBarControllerDelegate, Scenario {
    
    let aStage: UIViewController = UIViewController()
    
    let bStage: UIViewController = UIViewController()
    
    let tabBarController: UITabBarController = UITabBarController()
    
    var loginSequence: SceneSequence<UIViewController>?
    var aSequence: SceneSequence<UIViewController>?
    var bSequence: SceneSequence<UIViewController>?
    
    weak var root: UIViewController?
    
    func handleContext<T>(context: T) {
        if (aSequence == nil) {
            let aXIB = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
            aSequence = SceneSequence(aStage)
            aSequence?.start(aXIB, Sample2AViewController.self, false) { (stage, scene) in
                stage.addChildViewController(scene)
                stage.view.addSubview(scene.view)
            }
            root?.addChildViewController(tabBarController)
            root?.view.addSubview(tabBarController.view)
        }

    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            if (aSequence == nil) {
                let aXIB = ViewControllerXIBFile("Sample2AViewController", Bundle.main)
                aSequence = SceneSequence(aStage)
                aSequence?.start(aXIB, Sample2AViewController.self, false) { (stage, scene) in
                    stage.addChildViewController(scene)
                    stage.view.addSubview(scene.view)
                }
            }
            break
        case 1:
            if (bSequence == nil) {
                let aXIB = ViewControllerXIBFile("Sample2BViewController", Bundle.main)
                aSequence = SceneSequence(bStage)
                aSequence?.start(aXIB, Sample2BViewController.self, false) { (stage, scene) in
                    stage.addChildViewController(scene)
                    stage.view.addSubview(scene.view)
                }
            }

            break
        default:
            break
        }
    }
    
    func start(root: UIViewController) {
        // Set up Root
        self.root = root
        
        // Set up UITabBarController
        aStage.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: 1)
        bStage.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 2)

        tabBarController.setViewControllers([UINavigationController(rootViewController: aStage),
                                             UINavigationController(rootViewController: bStage)], animated: false)
        
        aStage.navigationItem.hidesBackButton = true
        aStage.navigationController?.setNavigationBarHidden(true, animated: true)
        
        bStage.navigationItem.hidesBackButton = true
        bStage.navigationController?.setNavigationBarHidden(true, animated: true)

        tabBarController.delegate = self
        tabBarController.selectedIndex = 0
        
        // Start Sequence
        loginSequence = SceneSequence(root, self)
        let name = "Sample2ViewController"
        loginSequence?.start(ViewControllerXIBFile(name, Bundle.main), Sample2ViewController.self) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
        }
    }
    
}
