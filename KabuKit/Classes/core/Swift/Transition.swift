//
//  Copyright © 2017 crexista
//

import Foundation

public struct Transition<StageType: AnyObject> {

    internal let execution: (_ stage: StageType, _ scene: SceneBase) -> Void
    
    internal let scene: SceneBase
    
    internal let args: Any?
    
    init<S: Scene>(_ newScene: S,
                    _ argument: S.ArgumentType?,
                    _ onTransition: @escaping (StageType, S) -> Void) where StageType == S.RouterType.DestinationType.StageType {
        
        self.scene = newScene        
        self.execution = { (_ stage: StageType, _ scene: SceneBase) -> Void in
            guard let neoScene = scene as? S else { return }
            onTransition(stage, neoScene)
        }
        self.args = argument
    }
}
