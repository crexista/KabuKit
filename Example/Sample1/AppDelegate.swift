//
//  AppDelegate.swift
//  Sample1
//
//  Created by crexista on 2016/11/21.
//  Copyright © crexista. All rights reserved.
//

import UIKit
import KabuKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var root: UIViewController?
    
    var sequence: SceneSequence<Sample1AViewController, SampleSequenceRule>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = UIViewController()
        self.window!.makeKeyAndVisible()

        let scene = Sample1AViewController(nibName: "Sample1AViewController", bundle: Bundle.main)
        let rule = SampleSequenceRule()
        let builder = SceneSequence.builder(scene: scene, guide: rule)
            .setup(UINavigationController(rootViewController: UIViewController()), with: false)

        sequence = builder.build {
            let stage = $0.stage
            let scene = $0.firstScene
            stage.isNavigationBarHidden = true
            stage.pushViewController(scene, animated: true)

            $0.callbacks.onActivate { (screens) in
                self.window?.rootViewController?.addChild(stage)
                self.window?.rootViewController?.view.addSubview(stage.view)
            }

            $0.callbacks.onSuspend { (screens) in
                stage.view.removeFromSuperview()
                stage.removeFromParent()
            }

            return {}
        }
        sequence?.activate()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the director to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the director from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
