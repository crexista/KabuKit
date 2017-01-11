//
//  Copyright © 2017年 crexista
//

import Foundation

public protocol  Scenario2 : class {
    
    func start(producer: Producer)
    
    func handleEvent<S, E>(sequence: SceneSequence2<S>, event: E, producer: Producer?)
}
