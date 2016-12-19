//
//  Copyright © 2016 crexista.
//

import Foundation

public protocol Scenario : class {
    
    func onEvent<StageType: AnyObject, EventType>(currentStage: StageType,
                                                  currentSequence: SceneSequence<StageType>,
                                                  currentScene: SceneBase,
                                                  event: EventType)
}
