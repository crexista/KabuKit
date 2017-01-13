//
//  Copyright © 2017 crexista
//

import Foundation

// NOTE ここら辺を同じファイルにまとめておかないとSegment fault が起きる


public protocol Action : SignalClosable {
    
    associatedtype SceneType: Scene
    
    func invoke(director: Director<SceneType.RouterType.DestinationType>) -> [ActionEvent]
    
    func onError(error: ActionError<Self>) -> RecoverPattern
}

public protocol SignalClosable {
    
    func onStop()
}


public struct ActionError<A: Action>: Error {
    public let from: A
    public let event: ActionEvent
    public let cause: Error
}

