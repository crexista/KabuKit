import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, Stage> : SceneCollection<FirstScene, Stage>, Scene, ScreenContainer {

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
    
    private let isRecordable: Bool
    private let firstScene: FirstScene
    private let guide: Any
    private let leaveFunc: ((Stage, [Screen], ReturnValue) -> Void)?
    private let initFunc: (Stage, FirstScene) -> (() -> Void)?
    private var subscriber: SequenceStatusSubscriber?

    public private(set) var isStarted: Bool = false
    public private(set) var isSuspended: Bool = false

    public static func builder<GuideType: SequenceGuide>(scene: FirstScene,
                                                         guide: GuideType) -> SceneSequenceBuilder<GuideType, Unbuildable, Unbuildable> where GuideType.FirstScene == FirstScene, GuideType.Stage == Stage {
        return SceneSequenceBuilder<GuideType, Unbuildable, Unbuildable>(scene: scene, guide: guide)
    }
    
    /**
     SequenceをSuspendします
     現状activeなScreenもsuspendモードに入ります
     起動してない状態時によばれたばあいは何も反応しません
     
     */
    public func suspend(_ completion: ((Bool) -> Void)?) {
        super.operation.transitionQueue.async {
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
        super.operation.transitionQueue.async {
            if(self.isStarted && !self.isSuspended) {
                completion?(false)
                return
            }
            if(!self.isStarted) {
                self.isStarted = true
                self.add(self.firstScene, with: self.context, transition: { (stage, scene, screen) -> (() -> Void)? in
                    return self.initFunc(stage, scene)
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
    

    public init<GuideType: SequenceGuide>(stage: Stage,
                                          scene: FirstScene,
                                          guide: GuideType,
                                          context: FirstScene.Context,
                                          subscriber: SceneSequence<FirstScene, Stage>.SequenceStatusSubscriber,
                                          onStart: @escaping (Stage, FirstScene) -> (() -> Void)?) where GuideType.Stage == Stage, GuideType.FirstScene == FirstScene {
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.subscriber = subscriber
        self.initFunc = { (stage: Stage, scene: FirstScene) in
            return onStart(stage, scene)
        }
        self.leaveFunc =  nil
        super.init(stage: stage, guide: guide)
        super.operation = SceneOperation(stage: stage, queue: guide.transitioningQueue, sequence: self)
        guide.start(with: super.operation)
        self.registerContext(context)
        self.registerOnResume { self.subscriber?.activateFunc?(self.screens) }
        self.registerOnSuspend { self.subscriber?.suspendFunc?(self.screens) }
        self.registerRewind { (value) in self.subscriber?.leaveFunc?(self.screens, value, false) }
    }
}
