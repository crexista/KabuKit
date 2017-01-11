//
//  Copyright © 2017年 crexista
//

import Foundation

public protocol Action2 : ActionTerminate {
    
    associatedtype DestinationType: Destination
    
    func invoke(director: Director<DestinationType>) -> [ObserverTarget]
    
}

public protocol ActionTerminate {
    func onError(error: Error, label: String?) -> ActionRecoverPattern
    func onStop()
}
