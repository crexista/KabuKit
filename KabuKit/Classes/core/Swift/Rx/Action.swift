//
//  Copyright © 2016 crexista.
//

import Foundation
import RxSwift

public protocol Action : class, OnStop, OnError {
    
    associatedtype SceneType: Scene
    
    func start(director: SceneDirector<SceneType.TransitionType>?, argument: SceneType.ArgumentType?)->[Observable<()>]
}

public protocol OnStop {
    func onStop()
}

public protocol OnError {
    func onError(error: Error)
}
