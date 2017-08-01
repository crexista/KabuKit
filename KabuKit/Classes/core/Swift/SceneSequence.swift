import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, GuideType: SequenceGuide> : Scene, SceneContainer {

    public typealias Context = FirstScene.Context
    
    public typealias StageType = GuideType.Stage
    
    private var scenes: [Screen]
    
    private var currentTransitionProcedure: TransitionProcedure?
    
    private let isRecordable: Bool
    
    private var stage: StageType?
    
    private var guide: GuideType?
    
    private var operation: SceneOperation<StageType>?
        
    private let firstScene: FirstScene
    
    private var leaveFunc:(([Screen]) -> Void)?
    
    public private(set) var isStarted: Bool = false


    /**
     ScreenをこのSequenceに追加します
    
     - Parameters:
       - screen: 新たにライフサイクルの管理を行うことになるScreen
       - onComplete: 追加作業が終わったら呼ばれるコールバック
     */
    internal func add(screen: Screen, _ onComplete:() -> Void) {
        guard  let operation = self.operation else { return }

        self.guide?.start(with: operation)
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
    internal func remove(screen: Screen, completion: () -> Void) {
        let hashwrap = ScreenHashWrapper(screen)
        _ = self.scenes.popLast()
        procedureByScene.removeValue(forKey: hashwrap)
        contextByScreen.removeValue(forKey: hashwrap)
        completion()
    }

    public func contain<SceneType: Scene>(_ scene: SceneType) -> Bool {
        return self.scenes.contains { (screen) -> Bool in
            (scene === screen)
        }
    }
    
    /**
     SceneSequenceをスタートさせます
    
     - Attention:
     起動時の処理のみ規定するため、leaveが呼ばれてもこのsequenceを停止させる処理は動かず
     このSequenceに追加された一番最初のSceneはreleaseされません
     
     - Parameters:
       - stage: Sequenceに追加されるSceneを乗せるView
       - invoking: 起動時の描画処理
       - runOn: 起動時の描画処理を行うDispatchQueue(async)
       - completion: setup処理が完了した時に呼ばれるコールバック
     */
    public func start(on stage: StageType,
                      invoking: @escaping (_ scene: FirstScene, _ stage: StageType) -> Void,
                      runOn: DispatchQueue = DispatchQueue.main,
                      _ completion: (() -> Void)? = nil) {
        
        let operation = SceneOperation(stage: stage, container: self)
        self.stage = stage
        self.guide?.start(with: operation)
        self.operation = operation

        firstScene.registerContext(self.context)
        add(screen: firstScene) {
            runOn.async {
                invoking(self.firstScene, stage)
                self.isStarted = true
                completion?()
            }
        }
    }

    /**
     SceneSequenceをスタートさせます

     - Parameters:
       - stage: Sequenceに追加されるSceneを乗せるView
       - transitioning: SceneSequenceを起動、終了させた時の遷移処理
       - runOn: 遷移処理を走らせるDisptachQueue(async)
       - didInvoked: 起動時の遷移処理がおわた時に呼ばれるコールバック
       - didClose: このSceneSequenceの処理が終了した際に呼ばれるコールバック
    */
    public func start(on stage: StageType,
                      transitioning : @escaping (_ scene: FirstScene, _ stage: StageType) -> (_ screens: [Screen]) -> Void,
                      runOn: DispatchQueue = DispatchQueue.main,
                      _ didInovke: (() -> Void)? = nil,
                      _ didClose: (() -> Void)? = nil) {
        
        let operation = SceneOperation(stage: stage, container: self)
        self.stage = stage
        self.guide?.start(with: operation)
        self.operation = operation
        
        firstScene.registerContext(self.context)
        add(screen: firstScene) {
            runOn.async {
                let rewind = transitioning(self.firstScene, stage)
                self.registerRewind {
                    rewind(self.scenes)
                    didClose?()

                }
                self.firstScene.registerRewind {
                    self.leaveFromSequence()
                }
                self.isStarted = true
                didInovke?()
            }
        }
    }
    
    /**
     SceneSequenceを生成する
    
     - Parameters:
       - scene: 一番最初のScene
       - guide: SceneSequenceのフローを書いたプロトコルクラス
       - context: 一番最初のSceneを開始する際に必要となる起動引数
     */
    public init(scene: FirstScene, guide: GuideType?, context: FirstScene.Context) {
        self.scenes = [Screen]()
        self.guide = guide
        self.isRecordable = true
        self.firstScene = scene
        self.registerContext(context)
    }
}


