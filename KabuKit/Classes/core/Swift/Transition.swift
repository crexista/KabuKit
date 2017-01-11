//
//  Copyright © 2017年 crexista
//

import Foundation

public struct Transition<StageType: AnyObject> {
    
    internal let setupFunc: (SceneSequence2<StageType>) -> Void
    
    internal let callBack: (StageType) -> Void
    
    internal func setupScene(sequence: SceneSequence2<StageType>) {
        setupFunc(sequence)
    }
    
    internal func onTransition(stage: StageType) {
        callBack(stage)
    }
    
    init<S: Scene2>(_ newScene: S,
                    _ argument: S.ArgumentType?,
                    _ onTransition: @escaping (StageType, S) -> Void) where StageType == S.RouterType.DestinationType.StageType {
        
        self.setupFunc = { (sequence: SceneSequence2<StageType>) in
            newScene.setup(sequence: sequence, arguments: argument)
        }
        self.callBack = { (stage: StageType) in
            onTransition(stage, newScene)
        }
    }
}
