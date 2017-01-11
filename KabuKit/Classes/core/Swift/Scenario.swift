//
//  Copyright © 2017 crexista
//

import Foundation

public protocol  Scenario : class {
    
    func start(producer: Producer)
    
    func handleEvent<S, E>(sequence: SceneSequence<S>, event: E, producer: Producer?)
}
