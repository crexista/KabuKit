//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit


extension Sample1AViewController: Scene {

    
    typealias Context = Bool
    typealias ReturnValue = String
    
    func onPressAButton(sender: UIButton) {
        sendTransitionRequest(SampleARequest(true){ value in })
    }
    
    func onPressBButton(sender: UIButton) {
        sendTransitionRequest(SampleBRequest(), { (str) in })
    }
    
    func onPressPrevButton(sender: UIButton) {
        leaveFromCurrent(returnValue: "back from sample1a", runTransition: true) { (result) in }
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
            leaveFromCurrent(returnValue: "test", runTransition: false)
        }
    }
}
