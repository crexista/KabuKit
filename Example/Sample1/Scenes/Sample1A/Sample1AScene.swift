//
//  Sample1AScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1AViewController: ActionScene {
    
    // MARK: - SceneTransition Protocol
    enum Sample1Link : SceneTransition {
        typealias StageType = UIViewController
        case A, B
        
        func request(context: SceneContext<UIViewController>) -> SceneRequest? {
            switch self {
            case .A:
                let xib = ViewControllerXIBFile("Sample1AViewController", Bundle.main)
                return context.sceneRequest(xib, Sample1AViewController.self, true) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            case .B:
                let xib = ViewControllerXIBFile("Sample1BViewController", Bundle.main)
                return context.sceneRequest(xib, Sample1BViewController.self, nil) { (stage, scene) in
                    stage.navigationController?.pushViewController(scene, animated: true)
                }
            }
        }
    }

    // MARK: - ActionScene Protocol
    typealias TransitionType = Sample1Link
    typealias ArgumentType = Bool

    func onRelease(stage: UIViewController) -> Bool {
        _ = stage.navigationController?.popViewController(animated: true)
        return true
    }

    // MARK: - Override
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        prevButton.isEnabled = argument!
        let action = Sample1AAction(label: label, buttonA: nextButtonA, buttonB: nextButtonB, prevButton: prevButton)
        observer.activate(action: action, director: self.director, argument: self.argument)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil && !isReleased) {
            director?.exitScene()
        }
    }

}
