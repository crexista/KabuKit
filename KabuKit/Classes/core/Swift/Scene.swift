import Foundation

internal var contextByScreen = [ScreenHashWrapper : Any]()

public protocol Scene : class, Screen {
    
    associatedtype Context
    
    var context: Context? { get }

}

extension Screen where Self: Scene {
    
    public var context: Context? {
        return contextByScreen[ScreenHashWrapper(self)] as? Self.Context
    }

}
