//
//  Sample2Scenario.swift
//  Example
//
//  Created by crexista on 2016/11/25.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit
import UIKit

@objc class Sample2Scenario: NSObject, UITabBarControllerDelegate, Scenario {
    
    let root: UIViewController    

    let aStage: UIViewController = UIViewController()
    
    let bStage: UIViewController = UIViewController()
    
    let tabBarController: UITabBarController = UITabBarController()

    var loginSequence: SceneSequence<UIViewController>?

    var aSequence: SceneSequence<UIViewController>?
    
    var bSequence: SceneSequence<UIViewController>?
    
    func start(producer: Producer) {
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
        let scene = Sample2ViewController(nibName: "Sample2ViewController", bundle: Bundle.main)
        let sceneA = Sample2AViewController(nibName: "Sample2AViewController", bundle: Bundle.main)
        let sceneB = Sample2AViewController(nibName: "Sample2BViewController", bundle: Bundle.main)
        
        loginSequence = SceneSequence(root, scene, nil) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
            scene.view.frame = stage.view.frame
        }
        
        aSequence = SceneSequence(aStage, sceneA, false) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
            scene.view.frame = stage.view.frame
        }
        
        bSequence = SceneSequence(bStage, sceneB, false) { (stage, scene) in
            stage.addChildViewController(scene)
            stage.view.addSubview(scene.view)
            scene.view.frame = stage.view.frame
        }
        
        producer.startSequence(sequence: loginSequence!)
    }
    
    func describe<E, S>(_ event: E, from sequence: SceneSequence<S>, through producer: Producer?) {
        
        if let eve = event as? String {
            if (eve == "start") {
                root.addChildViewController(tabBarController)
                root.view.addSubview(tabBarController.view)
                producer?.startSequence(sequence: aSequence!)
                producer?.startSequence(sequence: bSequence!)
            }
        }
    }
    
    init(root: UIViewController) {
        self.root = root
    }
 
}
