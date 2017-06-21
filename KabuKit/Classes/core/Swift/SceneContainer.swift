import Foundation

internal protocol SceneContainer : class {
    
    func add<T>(screen: Screen, context: T?, rewind: @escaping () -> Void)
    
    func remove(screen: Screen, completion: () -> Void)

}
