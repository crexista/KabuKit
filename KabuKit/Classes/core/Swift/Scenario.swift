//
//  Copyright © 2017 crexista
//

import Foundation

public protocol  Scenario : class {
    
    func start(producer: Producer)
    
    func describe<E, S>(_ event: E, from sequence: SceneSequence<S>, through producer: Producer?)
}
