//
//  Sample1BScene.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © crexista. All rights reserved.
//

import Foundation
import KabuKit

extension Sample1BViewController : Scene {
 
    typealias Context = Void

    @objc func onPressAButton(sender: UIButton) {
        sendTransitionRequest(SampleARequest(true){ _ in })
    }
    
    @objc func onPressBButton(sender: UIButton) {
        sendTransitionRequest(SampleBRequest(()))
    }
    
    @objc func onPressPrevButton(sender: UIButton) {
        leaveFromCurrent(returnValue: ())
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
}
