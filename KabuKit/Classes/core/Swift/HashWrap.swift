import Foundation

class HashWrap : Hashable {
    
    let hashValue: Int
    
    weak var scene: Page?
    
    static func ==(lhs: HashWrap, rhs: HashWrap) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    init(_ scene: Page) {
        self.scene = scene
        hashValue = Unmanaged<AnyObject>.passUnretained(scene).toOpaque().hashValue
    }
    
}
