import Foundation

internal var contextByScreen = [ScreenHashWrapper : Any]()

public protocol Scene : class, Screen {
    
    associatedtype ContextType
    
    var context: ContextType? { get }

}

extension Screen where Self: Scene {
    
    public var context: ContextType? {
        return contextByScreen[ScreenHashWrapper(self)] as? Self.ContextType
    }

}
