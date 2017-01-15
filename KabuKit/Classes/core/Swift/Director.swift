//
//  Copyright © 2017 crexista
//

import Foundation

public class Director<DestinationType: Destination> {
    
    typealias StageType = DestinationType.StageType
    
    private weak var sequence: SceneSequence<StageType>?
    
    private var routing: (DestinationType) -> SceneTransition<DestinationType.StageType>?
    
    private var remove: (SceneSequence<StageType>?) -> Void
    
    public func forwardTo(_ destination: DestinationType) {
        let transition = routing(destination)
        sequence?.push(transition: transition!)
    }
    
    public func back() {
        self.remove(sequence)
    }
    
    public func report<E>(event: E) {
        sequence?.raiseEvent(event: event)
    }
        
    internal init<S: Scene>(scene: S, sequence: SceneSequence<StageType>) where S.RouterType.DestinationType == DestinationType {
        self.routing = { (destination: DestinationType) -> SceneTransition<DestinationType.StageType>? in
            
            return scene.router.connect(from: scene, to: destination)
        }
        self.remove = { (seq: SceneSequence?) in
            _ = seq?.release(scene: scene)
        }
        self.sequence = sequence
    }
}
