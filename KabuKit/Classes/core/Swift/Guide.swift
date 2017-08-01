//
//  Copyright © 2017 crexista
//

import Foundation

public protocol SequenceGuide {

    associatedtype Stage
    
    func start(with operation: SceneOperation<Stage>) -> Void
}
