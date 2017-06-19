//
//  Copyright © 2017 crexista
//

import Foundation

public protocol Guide {

    associatedtype Stage
    
    func start(with operation: Operation<Stage>) -> Void
}
