//
//  Copyright © 2017年 crexista
//

import Foundation

public class Director<RouterType: SceneRouter> {
    
    typealias DestinationType = RouterType.DestinationType
    
    typealias StageType = DestinationType.StageType
    
    private weak var sequence: SceneSequence2<StageType>?
    
    private var routing: (DestinationType) -> Transition<DestinationType.StageType>?
    
    private var remove: (SceneSequence2<StageType>?) -> Void
    
    func transitTo(request: DestinationType) {
        let transition = routing(request)
        sequence?.push(transition: transition!)
    }
    
    func back() {
        self.remove(sequence)
    }
    
    func raiseEvent<E>(event: E) {
        sequence?.raiseEvent(event: event)
    }
    
    init<SceneType: Scene2>(scene: SceneType, sequence: SceneSequence2<StageType>) where SceneType.RouterType == RouterType {
        self.routing = { [weak scene] (request: DestinationType) -> Transition<DestinationType.StageType>? in
            
            return scene?.router.handle(scene: scene!, request: request)
        }
        self.remove = { [weak scene] (seq: SceneSequence2?) in
            _ = seq?.release(scene: scene!)
        }
        self.sequence = sequence
    }
}
