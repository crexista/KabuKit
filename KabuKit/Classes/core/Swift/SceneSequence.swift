import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, GuideType: SequenceGuide> : Scene, SceneIterator, SceneContainer {

    public typealias Context = FirstScene.Context
    public typealias ReturnValue = FirstScene.ReturnValue
    public typealias StageType = GuideType.Stage
    
    fileprivate var scenes: [Screen]
    
    private var currentTransitionProcedure: TransitionProcedure?
    
    private let isRecordable: Bool
    
    fileprivate var stage: StageType?
    
    fileprivate var guide: GuideType?
    
    fileprivate var operation: SceneOperation<StageType>?
        
    private let firstScene: FirstScene
    
    private var leaveFunc:(([Screen]) -> Void)?
    
    fileprivate var onInit: ((FirstScene, StageType) -> (() -> Void)?)?
    
    public private(set) var isStarted: Bool = false
    public private(set) var isSuspended: Bool = false

    public static func builder(scene: FirstScene,
                               guide: GuideType?) -> SceneSequenceBuilder<FirstScene, GuideType, Unbuildable, Unbuildable> {

        
        return SceneSequenceBuilder<FirstScene, GuideType, Unbuildable, Unbuildable>(scene: scene, guide: guide)
    }

    /**
     ScreenをこのSequenceに追加します
    
     - Parameters:
       - screen: 新たにライフサイクルの管理を行うことになるScreen
       - onComplete: 追加作業が終わったら呼ばれるコールバック
     */
    internal func add<SceneType>(screen: SceneType, _ onComplete: () -> Void) where SceneType : Scene {
        guard  let operation = self.operation else { return }

        let scenario = operation.resolve(from: screen)
        screen.registerScenario(scenario: scenario)
        self.scenes.append(screen)
        onComplete()
    }
    
    /**
     指定のScreenをこのSequenceの管理から外します
     
     - Parameters:
       - screen: 管理から外すScreen
       - completion: remove処理が終わったら呼ばれるコールバック
     */
    internal func remove<SceneType>(screen: SceneType) where SceneType : Scene {
        let hashwrap = ScreenHashWrapper(screen)
        _ = self.scenes.popLast()
        procedureByScene.removeValue(forKey: hashwrap)
        contextByScreen.removeValue(forKey: hashwrap)
    }

    public func contain<SceneType: Scene>(_ scene: SceneType) -> Bool {
        return self.scenes.contains { (screen) -> Bool in
            (scene === screen)
        }
    }

    
    public func suspend() {
        onSuspend()
        isSuspended = true
    }
    
    public func resume() {
        onResume()
        isSuspended = false
    }
    
    public func activate(runOn: DispatchQueue = DispatchQueue.main, _ completion: (() -> Void)? = nil) {
        runOn.async {
            self.onResume()
            if (!self.contain(self.firstScene)) {
                self.add(screen: self.firstScene) {
                    guard let stage = self.stage else { return }
                    guard let rewind = self.onInit?(self.firstScene, stage) else { return }
                    self.firstScene.registerRewind(f: { (value) in
                        rewind()
                        self.remove(screen: self.firstScene)
                        self.rewind?(value)
                    })
                }
            }
            completion?()
        }
    }
    
    deinit {
        self.leaveFromCurrent(returnValue: nil)
    }
    
    /**
     SceneSequenceを生成する
    
     - Parameters:
       - scene: 一番最初のScene
       - guide: SceneSequenceのフローを書いたプロトコルクラス
       - context: 一番最初のSceneを開始する際に必要となる起動引数
     */
    public init(scene: FirstScene, guide: GuideType?, onInit: ((FirstScene, StageType) -> (() -> Void)?)?) {
        self.scenes = [Screen]()
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.onInit = onInit
    }
}

public class BuilderState {}
public class Buildable: BuilderState {}
public class Unbuildable: BuilderState {}

public class SceneSequenceBuilder<FirstScene: Scene, GuideType: SequenceGuide, Context: BuilderState, Stage: BuilderState> {
    
    public typealias StageType = GuideType.Stage
    public typealias ReturnValue = FirstScene.ReturnValue
    
    fileprivate let firstScene: FirstScene
    
    fileprivate let guide: GuideType?
    
    fileprivate var onInit: ((FirstScene, StageType) -> (() -> Void)?)?
    
    fileprivate var stage: StageType?
    fileprivate var context: FirstScene.Context?
    


    
    init(scene: FirstScene, guide: GuideType?) {
        self.firstScene = scene
        self.guide = guide
    }
    
    public func setup(_ stage: StageType, with context: FirstScene.Context) -> SceneSequenceBuilder<FirstScene, GuideType, Buildable, Buildable> {
        let builder = SceneSequenceBuilder<FirstScene, GuideType, Buildable, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setContext(_ context: FirstScene.Context) -> SceneSequenceBuilder<FirstScene, GuideType, Buildable, Stage> {
        let builder = SceneSequenceBuilder<FirstScene, GuideType, Buildable, Stage>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
    
    public func setStage(_ stage: StageType) -> SceneSequenceBuilder<FirstScene, GuideType, Context, Buildable> {
        let builder = SceneSequenceBuilder<FirstScene, GuideType, Context, Buildable>(scene: firstScene, guide: self.guide)
        builder.context = context
        builder.stage = stage
        return builder
    }
}

public extension SceneSequenceBuilder where Context == Buildable, Stage == Buildable {
    
    public func build(onActive: ((StageType, [Screen]) -> Void)? = nil,
                      onInit: ((FirstScene, StageType) -> Void)? = nil,
                      onSuspend: ((StageType, [Screen]) -> Void)? = nil,
                      onLeave: ((StageType, [Screen], ReturnValue?) -> Void)? = nil) -> SceneSequence<FirstScene, GuideType> {
        return buildWithRewind(onActive: onActive,
                               onInit: { (scene, stage) -> (() -> Void)? in
                                onInit?(scene, stage)
                                return nil
                               },
                               onSuspend: onSuspend,
                               onLeave: onLeave)
    }
    
    public func buildWithRewind(onActive: ((StageType, [Screen]) -> Void)? = nil,
                                onInit: ((FirstScene, StageType) -> (() -> Void)?)? = nil,
                                onSuspend: ((StageType, [Screen]) -> Void)? = nil,
                                onLeave: ((StageType, [Screen], ReturnValue?) -> Void)? = nil) -> SceneSequence<FirstScene, GuideType> {
        
        guard let stage = self.stage else { fatalError() }
        guard let context = self.context else { fatalError() }
        
        let sequence = SceneSequence(scene: firstScene, guide: guide, onInit: onInit)
        let operation = SceneOperation(stage: stage, iterator: sequence)
        
        sequence.stage = stage
        sequence.guide?.start(with: operation)
        sequence.operation = operation
        sequence.registerOnSuspend { onSuspend?(stage, sequence.scenes) }
        sequence.registerOnResume { onActive?(stage, sequence.scenes) }
        sequence.registerRewind { retValue in onLeave?(stage, sequence.scenes, retValue) }
        sequence.registerContext(context)
        
        firstScene.registerContext(context)
        return sequence
    }
}
