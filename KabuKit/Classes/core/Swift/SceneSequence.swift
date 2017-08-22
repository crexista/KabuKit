import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, Guide: SequenceGuide> : SceneCollection<Guide.Stage>, Scene, ScreenContainer {


    public typealias Context = FirstScene.Context
    public typealias ReturnValue = FirstScene.ReturnValue
    public typealias StageType = Guide.Stage
    
    typealias Stage = Guide.Stage
    
    private let isRecordable: Bool
    private let firstScene: FirstScene
    private let guide: Guide
    private let leaveFunc: ((Guide.Stage, [Screen], ReturnValue?) -> Void)?
    private let invokeFunc: (Guide.Stage, FirstScene) -> (() -> Void)?

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
        guide.transitioningQueue.async {
            if(self.isStarted && !self.isSuspended) {
                completion?(false)
                return
            }
            if(!self.isStarted) {
                self.isStarted = true
                self.stack(self.firstScene, with: self.context, transition: { (stage, scene, screen) -> (() -> Void)? in
                    return self.invokeFunc(stage, scene)
                }, callbackOf: { (returnValue) in
                    self.rewind?(returnValue)
                })
            }
            self.onActivate()
            self.isSuspended = false
            self.currentTopScreen?.behavior?.isSuspended = false
            completion?(true)
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
    public init(stage: Guide.Stage, scene: FirstScene, guide: Guide, context: FirstScene.Context,
                onInvoke: @escaping (Guide.Stage, FirstScene) -> (() -> Void)?,
                onActive: ((Guide.Stage, [Screen]) -> Void)? = nil,
                onSuspend: ((Guide.Stage, [Screen]) -> Void)? = nil,
                onLeave: ((Guide.Stage, [Screen], ReturnValue?) -> Void)? = nil) {
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.invokeFunc = onInvoke
        self.leaveFunc = onLeave
        super.init(stage: stage, guide: guide)
        self.registerContext(context)
        self.registerOnResume { onActive?(stage, self.screens) }
        self.registerOnSuspend { onSuspend?(stage, self.screens) }
        self.registerRewind { (value) in onLeave?(stage, self.screens, value) }
    }
}
