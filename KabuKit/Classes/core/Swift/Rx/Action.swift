//
//  Copyright © 2017 crexista
//

import Foundation

public protocol Action : SignalClosable {
    
    associatedtype SceneType: Scene
    
    associatedtype DestinationType: Destination
    
    func invoke(director: Director<DestinationType>) -> [ActionEvent]
    
}

public extension Action where Self.DestinationType == SceneType.RouterType.DestinationType {
    
}

public protocol SignalClosable {
    func onError(error: Error, label: String?) -> RecoverPattern
    func onStop()
}
