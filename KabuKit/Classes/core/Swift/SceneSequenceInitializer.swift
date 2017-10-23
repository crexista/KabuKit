//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import Foundation

public protocol State {}
public class Ready: State { private init(){} }
public class NotReady: State { private init(){} }

public class SceneSequenceInitializer<FirstScene: Scene, Guide: SequenceGuide, Initializing: State> {
    
    public typealias ReturnValue = FirstScene.ReturnValue
    public typealias InitializeContext = (
        stage: Guide.Stage,
        firstScene: FirstScene
    )
    
    public typealias LeaveContext = (
        returnValue: FirstScene.ReturnValue?,
        screens: [Screen]
    )
    
    fileprivate let firstScene: FirstScene
    fileprivate let guide: Guide
    
    fileprivate var stage: Guide.Stage!
    fileprivate var context: FirstScene.Context?
    fileprivate var handler: ((InitializeContext) -> (() -> Void)?)?
    
    init(scene: FirstScene, guide: Guide) {
        self.firstScene = scene
        self.guide = guide
    }
    
    init(scene: FirstScene, guide: Guide, stage: Guide.Stage) {
        self.firstScene = scene
        self.guide = guide
        self.stage = stage
    }

    
    static func setup(_ scene: FirstScene, guide: Guide) -> SceneSequenceInitializer<FirstScene, Guide, NotReady> {
        return SceneSequenceInitializer<FirstScene, Guide, NotReady> (scene: scene, guide: guide)
    }
    
    static func setup(_ scene: FirstScene, guide: Guide, on stage: Guide.Stage) -> SceneSequenceInitializer<FirstScene, Guide, Ready> {
        return SceneSequenceInitializer<FirstScene, Guide, Ready> (scene: scene, guide: guide)
    }
        
}

public extension SceneSequenceInitializer where Initializing == NotReady {
    
    public func on(_ stage: Guide.Stage) -> SceneSequenceInitializer<FirstScene, Guide, Ready>{
        return SceneSequenceInitializer<FirstScene, Guide, Ready> (scene: firstScene, guide: guide, stage: stage)
    }
}

public extension SceneSequenceInitializer where Initializing == Ready {
    
    public func invoke(handler: @escaping (InitializeContext) -> ((LeaveContext) -> Void)) -> SceneSequnceStarter<FirstScene, Guide> {
        return SceneSequnceStarter<FirstScene, Guide>(firstScene: firstScene, guide: guide, stage: stage, handler: handler)
    }
}



