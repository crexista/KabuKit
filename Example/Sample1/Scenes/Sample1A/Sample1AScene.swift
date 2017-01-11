//
//  Sample1AScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1AViewController: Scene2, SceneLinkage {
    
    enum Sample1Destination: Destination {
        typealias StageType = UIViewController
        case a
        case b
    }
    
    typealias DestinationType = Sample1Destination
    
    typealias ArgumentType = Bool
    
    public var isRemovable: Bool {
        return true
    }
    

    func onMove(destination: Sample1Destination) -> Transition<UIViewController>? {

        switch destination {
        case .a:
            let scene = Sample1AViewController(nibName: "Sample1AViewController", bundle: Bundle.main)
            return destination.makeTransition(scene, false, { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            })
            
        case .b:
            let scene = Sample1BViewController(nibName: "Sample1BViewController", bundle: Bundle.main)
            return destination.makeTransition(scene, nil, { (stage, scene) in
                stage.navigationController?.pushViewController(scene, animated: true)
            })
            
        }
    }
    
    /**
     Sceneが削除されるときに呼ばれます.
     画面上から消すための処理をここに記述してください
     
     */
    public func onRemove(stage: UIViewController) {
        _ = stage.navigationController?.popViewController(animated: true)
    }

    
    func onPressAButton(sender: UIButton) {
        director?.transitTo(Sample1Destination.a)
    }
    
    func onPressBButton(sender: UIButton) {
        director?.transitTo(Sample1Destination.b)
    }
    
    func onPressPrevButton(sender: UIButton) {
        director?.back()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        prevButton.isEnabled = argument!
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil && !isRemovable) {
            director?.back()
        }
    }
}
