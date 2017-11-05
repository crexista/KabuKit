//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import Foundation

public protocol State {}
public class Ready: State { private init(){} }
public class NotReady: State { private init(){} }
public struct LeaveContext {
    public let screens: [Screen]
}

public typealias OnLeave = (LeaveContext) -> Void
public class SceneSequenceInitializer<Guide: SequenceGuide, Initializing: State> {
    public typealias Subscriber = SceneSequence<Guide.FirstScene, Guide.Stage>.SequenceStatusSubscriber
    public typealias ReturnValue = Guide.FirstScene.ReturnValue
    public typealias InitializeContext = (
        stage: Guide.Stage,
        firstScene: Guide.FirstScene,
        callbacks: Subscriber
    )
    


    
    fileprivate let firstScene: Guide.FirstScene
    fileprivate let guide: Guide
    
    fileprivate var stage: Guide.Stage!
    fileprivate var context: Guide.FirstScene.Context?
    fileprivate var handler: ((InitializeContext) -> (() -> Void)?)?
    
    init(scene: Guide.FirstScene, guide: Guide) {
        self.firstScene = scene
        self.guide = guide
    }
    
    init(scene: Guide.FirstScene, guide: Guide, stage: Guide.Stage) {
        self.firstScene = scene
        self.guide = guide
        self.stage = stage
    }

    
    static func setup(_ scene: Guide.FirstScene, guide: Guide) -> SceneSequenceInitializer<Guide, NotReady> {
        return SceneSequenceInitializer<Guide, NotReady> (scene: scene, guide: guide)
    }
    
    static func setup(_ scene: Guide.FirstScene, guide: Guide, on stage: Guide.Stage) -> SceneSequenceInitializer<Guide, Ready> {
        return SceneSequenceInitializer<Guide, Ready> (scene: scene, guide: guide)
    }
        
}

public extension SceneSequenceInitializer where Initializing == NotReady {
    
    public func on(_ stage: Guide.Stage) -> SceneSequenceInitializer<Guide, Ready>{
        return SceneSequenceInitializer<Guide, Ready> (scene: firstScene, guide: guide, stage: stage)
    }
}

public extension SceneSequenceInitializer where Initializing == Ready {
    
    public func invoke(handler: @escaping (InitializeContext) -> OnLeave) -> SceneSequnceStarter<Guide> {

        return SceneSequnceStarter<Guide>(firstScene: firstScene, guide: guide, stage: stage, handler: handler)
    }
}



