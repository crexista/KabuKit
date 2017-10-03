//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import Foundation

public class BuilderState {}
public class Buildable: BuilderState {}
public class Unbuildable: BuilderState {}

public class SceneSequenceBuilder<FirstScene: Scene, Guide: SequenceGuide, Context: BuilderState, Stage: BuilderState> {
    
    public typealias ReturnValue = FirstScene.ReturnValue
    
    fileprivate let firstScene: FirstScene
    fileprivate let guide: Guide
    
    fileprivate var stage: Guide.Stage?
    fileprivate var context: FirstScene.Context?
    
    init(scene: FirstScene, guide: Guide) {
        self.firstScene = scene
        self.guide = guide
    }
    
    public func setup(_ stage: Guide.Stage, with context: FirstScene.Context) -> SceneSequenceBuilder<FirstScene, Guide, Buildable, Buildable> {
        let builder = SceneSequenceBuilder<FirstScene, Guide, Buildable, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setContext(_ context: FirstScene.Context) -> SceneSequenceBuilder<FirstScene, Guide, Buildable, Stage> {
        let builder = SceneSequenceBuilder<FirstScene, Guide, Buildable, Stage>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setStage(_ stage: Guide.Stage) -> SceneSequenceBuilder<FirstScene, Guide, Context, Buildable> {
        let builder = SceneSequenceBuilder<FirstScene, Guide, Context, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
}

public extension SceneSequenceBuilder where Context == Buildable, Stage == Buildable {
    
    public typealias Subscriber = SceneSequence<FirstScene, Guide>.SequenceStatusSubscriber
    
    public typealias BuildArgument = (
        stage: Guide.Stage,
        firstScene: FirstScene,
        callbacks: Subscriber
    )
    
    @available(*, deprecated, message: "this method will be deleted at version 0.5.0")
    public func build(onInit: @escaping (Guide.Stage, FirstScene) -> Void,
                      onActive: ((Guide.Stage, [Screen]) -> Void)? = nil,
                      onSuspend: ((Guide.Stage, [Screen]) -> Void)? = nil,
                      onLeave: ((Guide.Stage, [Screen], ReturnValue?) -> Void)? = nil) -> SceneSequence<FirstScene, Guide> {
        return build(onInitWithRewind: { (stage, scene) -> (() -> Void)? in
            onInit(stage, scene)
            return nil
        },
                     onActive: onActive,
                     onSuspend: onSuspend,
                     onLeave: onLeave)
    }

    @available(*, deprecated, message: "this method will be deleted at version 0.5.0")
    public func build(onInitWithRewind: @escaping (Guide.Stage, FirstScene) -> (() -> Void)?,
                      onActive: ((Guide.Stage, [Screen]) -> Void)? = nil,
                      onSuspend: ((Guide.Stage, [Screen]) -> Void)? = nil,
                      onLeave: ((Guide.Stage, [Screen], ReturnValue?) -> Void)? = nil) -> SceneSequence<FirstScene, Guide> {
        
        guard let stage = self.stage else { fatalError() }
        guard let context = self.context else { fatalError() }
        
        return SceneSequence(stage: stage,
                             scene: firstScene,
                             guide: guide,
                             context: context,
                             onInit: onInitWithRewind,
                             onActive: onActive,
                             onSuspend: onSuspend,
                             onLeave: onLeave)
    }

    public func build(initializer: @escaping (BuildArgument) -> (() -> Void)?) -> SceneSequence<FirstScene, Guide> {
        guard let stage = self.stage else { fatalError() }
        guard let context = self.context else { fatalError() }
        let subscriber = SceneSequence<FirstScene, Guide>.SequenceStatusSubscriber()
        let onStart = { (stage: Guide.Stage, scene: FirstScene) -> (() -> Void)? in
            return initializer((stage, scene, subscriber))
        }

        return SceneSequence(stage: stage,
                             scene: firstScene,
                             guide: guide,
                             context: context,
                             subscriber: subscriber,
                             onStart: onStart)
    }
}
