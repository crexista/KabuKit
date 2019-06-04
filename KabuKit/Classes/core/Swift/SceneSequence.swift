import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, Guide: SequenceGuide> : SceneCollection<Guide.Stage>, Scene, ScreenContainer {

    public class SequenceStatusSubscriber {
        var activateFunc: (([Screen]) -> Void)?
        var suspendFunc: (([Screen]) -> Void)?
        var leaveFunc: (([Screen], FirstScene.ReturnValue, Bool) -> Void)?
        
        public func onActivate(_ f: @escaping ([Screen]) -> Void) {
            activateFunc = f
        }
        
        public func onSuspend(_ f: @escaping ([Screen]) -> Void) {
            suspendFunc = f
        }
        
        public func onLeave(_ f: @escaping ([Screen], FirstScene.ReturnValue, Bool) -> Void) {
            leaveFunc = f
        }
    }

    public typealias Context = FirstScene.Context
    public typealias ReturnValue = FirstScene.ReturnValue
    public typealias StageType = Guide.Stage
    
    typealias Stage = Guide.Stage
    
    private let isRecordable: Bool
    private let firstScene: FirstScene
    private let guide: Guide
    private let leaveFunc: ((Guide.Stage, [Screen], ReturnValue) -> Void)?
    private let initFunc: (Guide.Stage, FirstScene) -> (() -> Void)?
    private var subscriber: SequenceStatusSubscriber?

    public private(set) var isStarted: Bool = false
    public private(set) var isSuspended: Bool = false

    public static func builder(scene: FirstScene,
                               guide: Guide) -> SceneSequenceBuilder<FirstScene, Guide, Unbuildable, Unbuildable> {
        return SceneSequenceBuilder<FirstScene, Guide, Unbuildable, Unbuildable>(scene: scene, guide: guide)
    }
    
    /**
     SequenceをSuspendします
     現状activeなScreenもsuspendモードに入ります
     起動してない状態時によばれたばあいは何も反応しません
     
     */
    public func suspend(_ completion: ((Bool) -> Void)?) {
        guide.transitioningQueue.async {
            if (!self.isStarted || self.isSuspended) {
                completion?(false)
                return
            }
            self.isSuspended = true
            self.onSuspend()
            self.currentTopScreen?.behavior?.isSuspended = true
            completion?(true)
        }
    }
    
    
    /**
     Sequenceをactivateします
    
     - Parameters:
       - on: Sequenceを実行させるDispatchQueue
       - completion: 実行完了したさいに呼ばれるコールバック
     */
    public func activate(_ completion: ((Bool) -> Void)?) {
        let operation = SceneOperation(stage: stage, queue: guide.transitioningQueue)
        operation.setup(collection: self)
        guide.start(with: operation)

        guide.transitioningQueue.async {
            if(self.isStarted && !self.isSuspended) {
                completion?(false)
                return
            }
            if(!self.isStarted) {
                self.isStarted = true
                self.firstScene.context = self.context
                _ = self.initFunc(self.stage, self.firstScene)
                self.firstScene.registerScenario(scenario: operation.resolve(from: self.firstScene))
            }
            self.onActivate()
            self.isSuspended = false
            self.currentTopScreen?.behavior?.isSuspended = false
            completion?(true)
        }
    }
    
    /**
     SceneSequenceを生成する
    
     - Parameters:
       - scene: 一番最初のScene
       - guide: SceneSequenceのフローを書いたプロトコルクラス
       - context: 一番最初のSceneを開始する際に必要となる起動引数
     */
    @available(*, deprecated, message: "this method will be deleted at ver 0.5.0")
    public init(stage: Guide.Stage, scene: FirstScene, guide: Guide, context: FirstScene.Context,
                onInit: @escaping (Guide.Stage, FirstScene) -> (() -> Void)?,
                onActive: ((Guide.Stage, [Screen]) -> Void)? = nil,
                onSuspend: ((Guide.Stage, [Screen]) -> Void)? = nil,
                onLeave: ((Guide.Stage, [Screen], ReturnValue?) -> Void)? = nil) {
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.initFunc = onInit
        self.leaveFunc = onLeave
        super.init(stage: stage, guide: guide)
        self.subscriber = SequenceStatusSubscriber()
        self.subscriber?.activateFunc = { (args: [Screen]) in onActive?(stage, args) }
        self.subscriber?.suspendFunc = { (args: [Screen]) in onSuspend?(stage, args) }
        self.registerContext(context)
        self.registerOnResume { self.subscriber?.activateFunc?(self.screens) }
        self.registerOnSuspend { self.subscriber?.suspendFunc?(self.screens) }
        self.registerRewind { (value) in onLeave?(stage, self.screens, value) }
    }
    
    public init(stage: Guide.Stage,
                scene: FirstScene,
                guide: Guide,
                context: FirstScene.Context,
                subscriber: SceneSequence<FirstScene, Guide>.SequenceStatusSubscriber,
                onStart: @escaping (Guide.Stage, FirstScene) -> (() -> Void)?) {
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.subscriber = subscriber
        self.initFunc = { (stage: Guide.Stage, scene: FirstScene) in
            return onStart(stage, scene)
        }
        self.leaveFunc =  nil
        super.init(stage: stage, guide: guide)
        self.registerContext(context)
        self.registerOnResume { self.subscriber?.activateFunc?(self.screens) }
        self.registerOnSuspend { self.subscriber?.suspendFunc?(self.screens) }
        self.registerRewind { (value) in self.subscriber?.leaveFunc?(self.screens, value, false) }
    }
}
