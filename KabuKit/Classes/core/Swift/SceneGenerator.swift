//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol SceneGenerator {
    
    associatedtype argType
    
    associatedtype implType
    
    var argument: argType? { get }
    
    func generater(impl: implType.Type, argument: argType?) -> implType
    
}
