import Foundation
@testable import KabuKit

class DummyContainer: SceneContainer {
    
    var back: (() -> Void)?
    
    func add<T>(screen: Screen, context: T?, rewind: @escaping () -> Void) {
        self.back = rewind
    }
    
    func remove(screen: Screen, completion: () -> Void) {
        
    }
    
}
