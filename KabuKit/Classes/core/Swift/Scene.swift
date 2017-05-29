import Foundation

internal var contextByPage = [HashWrap : Any]()

public protocol Scene : class, Page {
    
    associatedtype ContextType
    
    var context: ContextType? { get }

}

extension Page where Self: Scene {
    
    public var context: ContextType? {
        return contextByPage[HashWrap(self)] as? Self.ContextType
    }

}
