//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit


extension Sample1AViewController: Scene {
    
    typealias ContextType = Bool
    
    func onPressAButton(sender: UIButton) {
        send(SampleARequest(true))
    }
    
    func onPressBButton(sender: UIButton) {
        send(SampleBRequest())
    }
    
    func onPressPrevButton(sender: UIButton) {
        leave()
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        if (context == true) {
            prevButton.isEnabled = true
            prevButton.alpha = 1.0
        } else {
            prevButton.isEnabled = false
            prevButton.alpha = 0.5
        }
        nextButtonA.addTarget(self, action: #selector(onPressAButton(sender:)), for: .touchUpInside)
        nextButtonB.addTarget(self, action: #selector(onPressBButton(sender:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(onPressPrevButton(sender:)), for: .touchUpInside)
    }
}