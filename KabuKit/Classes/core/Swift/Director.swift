//
//  Copyright © 2017年 crexista
//

import Foundation

public class Director<DestinationType: Destination> {
    
    typealias StageType = DestinationType.StageType
    
    private weak var sequence: SceneSequence2<StageType>?
    
    private var routing: (DestinationType) -> Transition<DestinationType.StageType>?
    
    private var remove: (SceneSequence2<StageType>?) -> Void
    
    public func transitTo(_ request: DestinationType) {
        let transition = routing(request)
        sequence?.push(transition: transition!)
    }
    
    public func back() {
        self.remove(sequence)
    }
    
    public func raiseEvent<E>(event: E) {
        sequence?.raiseEvent(event: event)
    }
    
    internal init<S: Scene2>(scene: S, sequence: SceneSequence2<StageType>) where S.RouterType.DestinationType == DestinationType {
        self.routing = { (request: DestinationType) -> Transition<DestinationType.StageType>? in
            
            return scene.router.handle(scene: scene, request: request)
        }
        self.remove = { (seq: SceneSequence2?) in
            _ = seq?.release(scene: scene)
        }
        self.sequence = sequence
    }
}
