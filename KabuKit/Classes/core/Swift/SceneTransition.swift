//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol SceneTransition {
    
    associatedtype StageType: AnyObject
    
    func request(context: SceneContext<StageType>) -> SceneRequest?
}
