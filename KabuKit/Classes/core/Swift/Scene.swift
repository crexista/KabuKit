import Foundation

internal var contextByPage = [HashWrap : Any]()

public protocol Scene : class, Page {
    
    associatedtype ContextType
    
    var context: ContextType? { get }

}

extension Page where Self: Scene {
    
    public internal(set) var context: ContextType? {
        get {
            return contextByPage[HashWrap(self)] as? Self.ContextType
        }
        
        set(value) {
            contextByPage[HashWrap(self)] = value
        }
    }

}
