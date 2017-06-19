import Foundation

class ScreenHashWrapper : Hashable {
    
    let hashValue: Int
    
    weak var screen: Screen?
    
    static func ==(lhs: ScreenHashWrapper, rhs: ScreenHashWrapper) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    init(_ screen: Screen) {
        self.screen = screen
        hashValue = Unmanaged<AnyObject>.passUnretained(screen).toOpaque().hashValue
    }
    
}
