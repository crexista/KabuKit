import Foundation
@testable import KabuKit

class DummyContainer: SceneContainer, SceneIterator {
    
    func contain<SceneType>(_ scene: SceneType) -> Bool where SceneType : Scene {
        return false
    }
    
    func activate(runOn: DispatchQueue, _ completion: (() -> Void)?) {

    }

    func resume() {

    }

    func suspend() {

    }

    
    var back: (() -> Void)?
    
    func add<T>(screen: Screen, context: T?, rewind: @escaping () -> Void) {
        self.back = rewind
    }
    
    func remove(screen: Screen, completion: () -> Void) {
        
    }
    
    func add<SceneType>(screen: SceneType, _ onComplete: () -> Void) where SceneType : Scene {
        
    }
    
    func remove<SceneType>(screen: SceneType) where SceneType : Scene {
        
    }

    
}
