//
//  Copyright © 2017 crexista
//

import Foundation

public protocol SequenceGuide {

    associatedtype Stage
    
    var transitioningQueue: DispatchQueue { get }
    
    func start(with operation: SceneOperation<Stage>) -> Void
}

public extension SequenceGuide {
    
    /**
     デフォルトではmain queue上でtransitionを行う
     
     */
    public var transitioningQueue: DispatchQueue {
        return DispatchQueue.main
    }
}
