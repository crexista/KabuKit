//
//  Sample1AScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1AViewController: Scene {
    
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
    
    public var isRemovable: Bool {
        return argument!
    }

    func onRemove(stage: UIViewController) {
        _ = stage.navigationController?.popViewController(animated: true)
    }
    
    func onPressAButton(sender: UIButton) {
        director?.changeScene(transition: Sample1Link.A)
    }
    
    func onPressBButton(sender: UIButton) {
        director?.changeScene(transition: Sample1Link.B)
    }

    func onPressPrevButton(sender: UIButton) {
        director?.exitScene()
    }

    // MARK: - Override
    override func viewDidLoad() {
        prevButton.isEnabled = argument!
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil && !isReleased) {
            director?.exitScene()
        }
    }

}
