import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<FirstScene: Scene, GuideType: Guide> : Scene, SceneContainer {

    public typealias Context = FirstScene.Context
    
    public typealias StageType = GuideType.Stage
    
    private var scenes: [Screen]
    
    private var currentTransitionProcedure: TransitionProcedure?
    
    private let isRecordable: Bool
    
    private var stage: StageType?
    
    private var guide: GuideType?
    

    private let dispatchQueue: DispatchQueue
    
    private let firstScene: FirstScene
    
    private var leaveFunc:(([Screen]) -> Void)?
    
    public private(set) var isStarted: Bool = false

    internal func add<ContextType>(screen: Screen, context: ContextType?, rewind: @escaping () -> Void) {
        let operation = SceneOperation<StageType>()
        self.guide?.start(with: operation)
        guard let scenario = operation.resolve(from: screen) else { return }
        let hashwrap = ScreenHashWrapper(screen)
        self.scenes.append(screen)
        procedureByScene[hashwrap] = scenario
        contextByScreen[hashwrap] = context
        scenario.setup(at: screen, on: self.stage!, with: self, when: rewind)
    }
    
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
     Sequenceをスタートさせます
     
     - Attention:
     起動時の処理のみ規定するため、leaveが呼ばれてもこのsequenceを停止させる処理は動かず
     
     このSequenceに追加された一番最初のSceneはreleaseされません
     
     - Parameters:
       - stage: 画面遷移の元の `stage` となるインスタンス
       - setup: Sequenceをスタートさせる際に画面表示など必要となるメソッド
     */
    public func start(on stage: StageType,
                      with setup: @escaping (_ scene: FirstScene, _ stage: StageType) -> Void) {
        self.start(on: stage, with: setup, {})
    }
    
    
    /**
     Sequenceをスタートさせます
     
     - Parameters:
       - stage: 画面遷移の元の `stage` となるインスタンス
       - setup: Sequenceをスタートさせる際に画面表示など必要となるメソッド
       - completion: Sequenceのsetupが完了したら呼ばれます
     */
    public func start(on stage: StageType,
                      with setup: @escaping (_ scene: FirstScene, _ stage: StageType) -> Void,
                      _ completion: @escaping () -> Void  = {}) {
        let operation = SceneOperation<StageType>()
        self.stage = stage
        self.guide?.start(with: operation)
        // TODO FIX, Any Pattern
        guard let scenario = operation.resolve(from: firstScene) else { return }
        scenario.setup(at: firstScene, on: stage, with: self, when: nil) {
            let hashwrap = ScreenHashWrapper(self.firstScene)
            self.scenes.append(self.firstScene)
            procedureByScene[hashwrap] = scenario
            contextByScreen[hashwrap] = self.context
            setup(self.firstScene, stage)
            completion()
            self.isStarted = true
        }
    }

    public func start(on stage: StageType,
                      accordingAs transitioningRule: @escaping (_ scene: FirstScene, _ stage: StageType) -> (_ screens: [Screen]) -> Void) {
        self.start(on: stage, accordingAs: transitioningRule, {})
    }
    
    /**
     Sequenceをスタートさせます
     transitioningにこのSequenceが起動する際の画面遷移ロジックと
     このSequenceがleaveする際の画面遷移ロジックを書きます
    
     - Parameters:
       - stage: 画面遷移を行う `stage` となるインスタンス
       - transitioning: Sequenceをスタートさせる際の遷移ロジック
     */
    public func start(on stage: StageType,
                      accordingAs transitioningRule : @escaping (_ scene: FirstScene, _ stage: StageType) -> (_ screens: [Screen]) -> Void,
                      _ completion: @escaping () -> Void = {}) {
        
        let operation = SceneOperation<StageType>()
        self.stage = stage
        self.guide?.start(with: operation)
        // TODO FIX, Any Pattern
        guard let scenario = operation.resolve(from: firstScene) else { return }
        scenario.setup(at: firstScene, on: stage, with: self, when: nil) {
            let hashwrap = ScreenHashWrapper(self.firstScene)
            self.scenes.append(self.firstScene)
            procedureByScene[hashwrap] = scenario
            contextByScreen[hashwrap] = self.context
            self.leaveFunc = transitioningRule(self.firstScene, stage)
            completion()
            self.isStarted = true
        }
    }
    
    /**
    これはスタブコード いずれ消します
    
    */
    public func leave(_ runTransition: Bool, _ completion: @escaping (Bool) -> Void) {
        if let leaveMethod = self.leaveFunc {
            leaveMethod(self.scenes)
            self.scenes.removeAll()
        }
        self.isStarted = false
        completion(true)
    }
    
    /**
     SceneSequenceを生成する
     
     - Parameters:
       - transition:  MEMO ruleという名前の方が良いかも・・・
       - isRecordable: trueがデフォルト。 Scene遷移の履歴を保存するのかのフラグ
                       ここがfalseだと履歴が保存されず、Sceneを実装したクラスの方でleave()を呼んでも何も起きない
     */
    public init(_ scene: FirstScene, _ guide: GuideType?, _ context: FirstScene.Context? = nil) {
        scenes = [Screen]()
        self.guide = guide
        self.isRecordable = true
        self.dispatchQueue = DispatchQueue.main
        self.firstScene = scene
    }
}


