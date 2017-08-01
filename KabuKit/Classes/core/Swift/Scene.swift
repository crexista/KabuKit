import Foundation

internal var contextByScreen = [ScreenHashWrapper : Any]()

public protocol Scene : class, Screen {
    
    associatedtype Context
    
    var context: Context { get }

}

extension Screen where Self: Scene {
    
    public var context: Context {
        return contextByScreen[ScreenHashWrapper(self)] as! Self.Context
    }

    internal func registerContext(_ value: Any?) {
        contextByScreen[ScreenHashWrapper(self)] = value as? Self.Context
    }
}
