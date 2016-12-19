//
//  Copyright © 2016 crexista.
//

import Foundation

public struct ViewControllerXIBFile : SceneGenerator {
    
    public typealias implType =  UIViewController
    public typealias argType = (String?, Bundle?)
    
    public let argument: argType?
    
    public func generater(impl: implType.Type, argument: argType?) -> implType {
        return impl.init(nibName: argument!.0, bundle: argument!.1)
    }
    
    public init (_ fileName: String?, _ bundle: Bundle?) {
        self.argument = (fileName, bundle)
    }
}
