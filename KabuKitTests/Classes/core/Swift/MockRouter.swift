//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit

class MockRouter: SceneRouter {
    typealias DestinationType = MockDestination
    
    func connect<S : Scene>(from scene: S, to destination: MockDestination) -> Transition<NSObject>? {
        return nil
    }
}
