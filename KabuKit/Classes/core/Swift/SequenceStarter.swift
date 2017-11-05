//
//  Copyright © 2017 crexista
//

import Foundation

public class Starter<FirstScene: Scene, Guide: SequenceGuide> {
}

public class SceneSequnceStarter<Guide: SequenceGuide> {
    public typealias ReturnValue = Guide.FirstScene.ReturnValue
    public typealias Subscriber = SceneSequence<Guide.FirstScene, Guide.Stage>.SequenceStatusSubscriber
    public typealias StarterContext = (
        stage: Guide.Stage,
        firstScene: Guide.FirstScene,
        callbacks: Subscriber
    )
    
    public typealias LeaveContext = (
        returnValue: Guide.FirstScene.ReturnValue?,
        screens: [Screen]
    )
    
    fileprivate let firstScene: Guide.FirstScene
    fileprivate let guide: Guide
    fileprivate var stage: Guide.Stage
    fileprivate var handler: ((StarterContext) -> OnLeave)?
    
    init(firstScene: Guide.FirstScene, guide: Guide, stage: Guide.Stage, handler: @escaping (StarterContext) -> OnLeave) {
        self.firstScene = firstScene
        self.guide = guide
        self.stage = stage
        self.handler = handler
    }
    
    public func start(with context: Guide.FirstScene.Context) -> SceneSequence<Guide.FirstScene, Guide.Stage> {
        
        let subscriber = SceneSequence<Guide.FirstScene, Guide.Stage>.SequenceStatusSubscriber()
        let onStart = { (stage: Guide.Stage, scene: Guide.FirstScene) -> OnLeave? in
            return self.handler?((stage, scene, subscriber))
        }
        
        return SceneSequence(stage: stage,
                             scene: firstScene,
                             guide: guide,
                             context: context,
                             subscriber: subscriber,
                             onStart: onStart)
    }
}
