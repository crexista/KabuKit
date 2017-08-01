//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit


extension Sample1AViewController: Scene {
    
    typealias Context = Bool
    
    func onPressAButton(sender: UIButton) {
        sendTransitionRequest(SampleARequest(true))
    }
    
    func onPressBButton(sender: UIButton) {
        sendTransitionRequest(SampleBRequest())
    }
    
    func onPressPrevButton(sender: UIButton) {
        leaveFromSequence()
    }

    func onPressPopButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        if (context == true) {
            prevButton.isEnabled = true
            prevButton.alpha = 1.0

            popButton.isEnabled = true
            popButton.alpha = 1.0
        } else {
            prevButton.isEnabled = false
            prevButton.alpha = 0.5

            popButton.isEnabled = false
            popButton.alpha = 0.5
        }
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
        popButton.addTarget(self, action: #selector(onPressPopButton(sender:)), for: .touchUpInside)
    }

    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            leaveFromSequence(false)
        }
    }
}
