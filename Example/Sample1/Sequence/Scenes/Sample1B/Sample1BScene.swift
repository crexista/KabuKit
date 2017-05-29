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
 
    typealias ContextType = Void

    func onPressAButton(sender: UIButton) {
        jumpTo(SampleALink(true))
    }
    
    func onPressBButton(sender: UIButton) {
        jumpTo(SampleBLink())
    }
    
    func onPressPrevButton(sender: UIButton) {
        prev()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
}
