import Foundation

internal var transitionByScene = [ScreenHashWrapper : Transition]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<C, G: Guide> : Scene, SceneContainer {

    public typealias ContextType = C
    
    public typealias StageType = G.Stage
    
    private var scenes: [Screen]
    
    private var currentTransition: Transition?
    
    private let isRecordable: Bool
    
    private var stage: StageType?
    
    private var guide: G?
    
    private var operation: Operation<G.Stage>?
    
    private let queue: DispatchQueue

    internal func add<T>(screen: Screen, context: T?, rewind: @escaping () -> Void) {
        guard let scenario = self.operation?.resolve(from: screen) else { return }
        let hashwrap = ScreenHashWrapper(screen)
        self.scenes.append(screen)
        transitionByScene[hashwrap] = scenario
        contextByScreen[hashwrap] = context
        scenario.setup(at: screen, on: self.stage!, with: self, when: rewind)
    }
    
    internal func remove(screen: Screen, completion: () -> Void) {
        let hashwrap = ScreenHashWrapper(screen)
        _ = self.scenes.popLast()
        transitionByScene.removeValue(forKey: hashwrap)
        contextByScreen.removeValue(forKey: hashwrap)
    }
    
    /**
     Sequenceをスタートさせる
     
     - Parameters:
       - stage: Sceneが乗っかるstageオブジェクト
       - scene: 起動させた際に一番最初に表示させる画面
       - context: sceneを表示させるさいに必要となるcontextオブジェクト
       - invoke: sceneを表示させるのに必要となる処理
     */
    public func startWith<S: Scene>(_ stage: StageType,
                                    _ scene: S,
                                    _ context: S.ContextType,
                                    _ invoke: @escaping (_ scene: S, _ stage: StageType) -> Void) {
        let operation = Operation<StageType>()
        self.stage = stage
        self.guide?.start(with: operation)
        self.operation = operation
        // TODO FIX, Any Pattern
        guard let scenario = operation.resolve(from: scene) else { return }
        
        scenario.setup(at: scene, on: stage, with: self, when: nil) {
            self.add(screen: scene, context: context, rewind: {})
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
    public init(_ guide: G?, _ isRecordable: Bool = true, _ queue: DispatchQueue = DispatchQueue.main) {
        scenes = [Screen]()
        self.guide = guide
        self.isRecordable = isRecordable
        self.queue = queue
    }
}


