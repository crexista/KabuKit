//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit

class MockRouter: SceneRouter {
    typealias DestinationType = MockDestination
    
    func handle<S : Scene2>(scene: S, request: MockDestination) -> Transition<NSObject>? {
        return nil
    }
}
