import Foundation

public protocol ScreenContainer {
    
    func suspend(_ completion: ((Bool) -> Void)?)
    
    func activate(_ completion: ((Bool) -> Void)?)
    
}

public extension ScreenContainer {
    
    public func activate() {
        activate(nil)
    }
    
    public func suspend() {
        suspend(nil)
    }
}
