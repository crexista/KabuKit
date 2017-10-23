//
//  Copyright © 2017 crexista
//

import Foundation

public class Starter<FirstScene: Scene, Guide: SequenceGuide> {
}

public class SceneSequnceStarter<FirstScene: Scene, Guide: SequenceGuide> {
    public typealias ReturnValue = FirstScene.ReturnValue
    public typealias StarterContext = (
        stage: Guide.Stage,
        firstScene: FirstScene
    )
    
    public typealias LeaveContext = (
        returnValue: FirstScene.ReturnValue?,
        screens: [Screen]
    )
    
    fileprivate let firstScene: FirstScene
    fileprivate let guide: Guide
    fileprivate var stage: Guide.Stage
    fileprivate var handler: ((StarterContext) -> (() -> Void)?)?
    
    init(firstScene: FirstScene, guide: Guide, stage: Guide.Stage, handler: (StarterContext) -> ((LeaveContext) -> Void)) {
        self.firstScene = firstScene
        self.guide = guide
        self.stage = stage
    }
    
    public func start(with context: FirstScene.Context, onLeave:(LeaveContext) -> Void) -> SceneSequence<FirstScene, Guide> {
        
        let subscriber = SceneSequence<FirstScene, Guide>.SequenceStatusSubscriber()
        let onStart = { (stage: Guide.Stage, scene: FirstScene) -> (() -> Void)? in
            return self.handler?((stage, scene))
        }
        
        return SceneSequence(stage: stage,
                             scene: firstScene,
                             guide: guide,
                             context: context,
                             subscriber: subscriber,
                             onStart: onStart)
    }
}
