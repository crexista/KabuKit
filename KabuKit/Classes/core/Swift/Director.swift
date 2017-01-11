//
//  Copyright © 2017 crexista
//

import Foundation

public class Director<DestinationType: Destination> {
    
    typealias StageType = DestinationType.StageType
    
    private weak var sequence: SceneSequence<StageType>?
    
    private var routing: (DestinationType) -> Transition<DestinationType.StageType>?
    
    private var remove: (SceneSequence<StageType>?) -> Void
    
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
    
    internal init<S: Scene>(scene: S, sequence: SceneSequence<StageType>) where S.RouterType.DestinationType == DestinationType {
        self.routing = { (request: DestinationType) -> Transition<DestinationType.StageType>? in
            
            return scene.router.handle(scene: scene, request: request)
        }
        self.remove = { (seq: SceneSequence?) in
            _ = seq?.release(scene: scene)
        }
        self.sequence = sequence
    }
}
