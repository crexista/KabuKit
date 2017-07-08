import Foundation

internal var procedureByScene = [ScreenHashWrapper : TransitionProcedure]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<ContextType, GuideType: Guide> : Scene, SceneContainer {

    public typealias Context = ContextType
    
    public typealias StageType = GuideType.Stage
    
    private var scenes: [Screen]
    
    private var currentTransitionProcedure: TransitionProcedure?
    
    private let isRecordable: Bool
    
    private var stage: StageType?
    
    private var guide: GuideType?
    
    private let dispatchQueue: DispatchQueue

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
    
    /**
     Sequenceをスタートさせる
     
     - Parameters:
       - stage: Sceneが乗っかるstageオブジェクト
       - scene: 起動させた際に一番最初に表示させる画面
       - context: sceneを表示させるさいに必要となるcontextオブジェクト
       - invoke: sceneを表示させるのに必要となる処理
     */
    public func startWith<SceneType: Scene>(_ stage: StageType,
                                    _ scene: SceneType,
                                    _ context: SceneType.Context,
                                    _ invoke: @escaping (_ scene: SceneType, _ stage: StageType) -> Void) {
        let operation = SceneOperation<StageType>()
        self.stage = stage
        self.guide?.start(with: operation)

        // TODO FIX, Any Pattern
        guard let scenario = operation.resolve(from: scene) else { return }
        scenario.setup(at: scene, on: stage, with: self, when: nil) {
            let hashwrap = ScreenHashWrapper(scene)
            self.scenes.append(scene)
            procedureByScene[hashwrap] = scenario
            contextByScreen[hashwrap] = context
            invoke(scene, stage)
        }
    }
    
    /**
     SceneSequenceを生成する
     
     - Parameters:
       - transition:  MEMO ruleという名前の方が良いかも・・・
       - isRecordable: trueがデフォルト。 Scene遷移の履歴を保存するのかのフラグ
                       ここがfalseだと履歴が保存されず、Sceneを実装したクラスの方でleave()を呼んでも何も起きない
     */
    public init(_ guide: GuideType?, _ isRecordable: Bool = true, _ queue: DispatchQueue = DispatchQueue.main) {
        scenes = [Screen]()
        self.guide = guide
        self.isRecordable = isRecordable
        self.dispatchQueue = queue
    }
}


