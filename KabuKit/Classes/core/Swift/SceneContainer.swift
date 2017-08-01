import Foundation

internal protocol SceneContainer : class {
    func add(screen: Screen, _ onComplete:() -> Void)

//    func add<ContextType>(screen: Screen, context: ContextType?, rewind: @escaping () -> Void)
    
    func remove(screen: Screen, completion: () -> Void)

}
