//
//  Copyright © 2017年 crexista
//

import Foundation

public protocol Action2 : ActionTerminate {
    
    associatedtype RouterType: SceneRouter
    
    func invoke(director: Director<RouterType>) -> [ObserverTarget]
    
}

public protocol ActionTerminate {
    func onError(error: Error, label: String?) -> ActionRecoverPattern
    func onStop()
}
