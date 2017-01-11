//
//  Copyright © 2017 crexista
//

import Foundation

public protocol Action : SignalClosable {
    
    associatedtype DestinationType: Destination
    
    func invoke(director: Director<DestinationType>) -> [SubscribeTarget]
    
}

public protocol SignalClosable {
    func onError(error: Error, label: String?) -> RecoverPattern
    func onStop()
}
