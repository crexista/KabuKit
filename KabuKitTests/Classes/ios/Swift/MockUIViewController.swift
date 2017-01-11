//
//  Copyright © 2017年 crexista
//

import UIKit
import KabuKit

class MockUIViewController: UIViewController, Scene{
    
    class MockTransition : SceneTransition {
        typealias StageType = UIViewController
        func request(context: SceneContext<UIViewController>) -> SceneRequest? {
            return nil
        }
    }
    
    typealias ArgumentType = Void
    
    typealias TransitionType = MockTransition

    public var isRemovable: Bool {
        return false
    }
    
    func onRemove(stage: UIViewController) {
        
    }
}
