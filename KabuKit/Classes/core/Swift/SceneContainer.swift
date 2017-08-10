import Foundation

protocol SceneIterator : class {
    
    func add<SceneType>(screen: SceneType, _ onComplete: () -> Void) where SceneType : Scene
    
    func remove<SceneType>(screen: SceneType) where SceneType : Scene
}

public protocol SceneContainer {
    
    func suspend()

    func resume()
    
    func activate(runOn: DispatchQueue, _ completion: (() -> Void)?)
    
    func contain<SceneType: Scene>(_ scene: SceneType) -> Bool
}

public extension SceneContainer {
    
    public func activate(_ completion: (() -> Void)?) {
        activate(runOn: DispatchQueue.main, completion)
    }
    
    public func activate(runOn: DispatchQueue) {
        activate(runOn: runOn, nil)
    }
    
    public func activate() {
        activate(runOn: DispatchQueue.main, nil)
    }
}
