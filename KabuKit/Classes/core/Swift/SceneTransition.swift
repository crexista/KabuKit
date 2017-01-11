//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol SceneTransition {
    
    associatedtype StageType: AnyObject
/*
    func transit<S: SceneGenerator, T: Scene>(generator: S, args:T.ArgumentType, onTransit: (T.RouterType.TransitionType.StageType, T)) -> SceneRequest2<T> where T == S.SceneType
*/
}
