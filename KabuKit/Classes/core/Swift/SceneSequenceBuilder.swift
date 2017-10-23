//
//  Copyright © 2017年 DWANGO Co., Ltd.
//

import Foundation

public class BuilderState {}
public class Buildable: BuilderState {}
public class Unbuildable: BuilderState {}

public class SceneSequenceBuilder<Guide: SequenceGuide, Context: BuilderState, Stage: BuilderState>  {
    
    public typealias FirstScene = Guide.FirstScene
    public typealias ReturnValue = FirstScene.ReturnValue
    
    fileprivate let firstScene: FirstScene
    fileprivate let guide: Guide
    
    fileprivate var stage: Guide.Stage?
    fileprivate var context: FirstScene.Context?
    
    init(scene: FirstScene, guide: Guide) {
        self.firstScene = scene
        self.guide = guide
    }
    
    public func setup(_ stage: Guide.Stage, with context: FirstScene.Context) -> SceneSequenceBuilder<Guide, Buildable, Buildable> {
        let builder = SceneSequenceBuilder<Guide, Buildable, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setContext(_ context: FirstScene.Context) -> SceneSequenceBuilder<Guide, Buildable, Stage> {
        let builder = SceneSequenceBuilder<Guide, Buildable, Stage>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setStage(_ stage: Guide.Stage) -> SceneSequenceBuilder<Guide, Context, Buildable> {
        let builder = SceneSequenceBuilder<Guide, Context, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
}

public extension SceneSequenceBuilder where Context == Buildable, Stage == Buildable {
    
    public typealias Subscriber = SceneSequence<FirstScene, Guide.Stage>.SequenceStatusSubscriber
    
    public typealias BuildArgument = (
        stage: Guide.Stage,
        firstScene: Guide.FirstScene,
        callbacks: Subscriber
    )

    public func build(initializer: @escaping (BuildArgument) -> (() -> Void)?) -> SceneSequence<FirstScene, Guide.Stage> {
        guard let stage = self.stage else { fatalError() }
        guard let context = self.context else { fatalError() }
        let subscriber = SceneSequence<FirstScene, Guide.Stage>.SequenceStatusSubscriber()
        let onStart = { (stage: Guide.Stage, scene: FirstScene) -> (() -> Void)? in
            return initializer((stage, scene, subscriber))
        }

        return SceneSequence<FirstScene, Guide.Stage>(stage: stage,
                             scene: firstScene,
                             guide: guide,
                             context: context,
                             subscriber: subscriber,
                             onStart: onStart)
    }
}
