//
//  Copyright © 2017 crexista
//

import Foundation
import KabuKit

class SimpleMockScene : NSObject, Scene {
    
    typealias RouterType = MockRouter
    typealias ContextType = Void
    
    public var router: MockRouter {
        return MockRouter()
    }
    
    public func willRemove(from stage: NSObject) {
        
    }
}
