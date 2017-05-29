import Foundation

internal var containerByScean = [HashWrap : LinkHandler]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<C, R: SequenceRule> : Scene, LinkHandler {

    public typealias ContextType = C
    
    public typealias StageType = R.StageType
    
    private var scenes: [HashWrap]
    
    private let isRecordable: Bool
    
    private var rule: R?
    
    private var stage: R.StageType?
    
    internal func handle<P: Page, T>(_ from: P, _ link: Link<T>) -> Bool {
        // SequenceRule及びstageがセットされていない場合は遷移ができないのでなにもしない
        guard let rule = self.rule else { return false }
        guard let stage = self.stage else { return false }

        let transition = rule.scenario.resolve(current: from, link: link)

        transition?.execute(from: from, stage: stage) { (nextPage) in
            guard self.isRecordable else { return }            
            let hashwrap = HashWrap(nextPage)
            scenes.append(hashwrap)
            contextByPage[hashwrap] = link.context
            containerByScean[hashwrap] = self
        }
        
        return true
    }
    
    internal func back<P: Page>(_ current: P) -> Bool {
        // SequenceRule及びstageがセットされていない場合は遷移ができないのでなにもしない
        guard self.rule != nil else { return false }
        guard let stage = self.stage else { return false }
        
        // どのようにSceneが積み重ねなれるかのフラグ.
        // isRecordable が flaseの時は保存されてないので戻れない
        guard isRecordable else { return false }
        
        let hashwrap = HashWrap(current)
        _ = scenes.popLast()
        containerByScean.removeValue(forKey: hashwrap)
        
        self.rule?.onEnd(page: current, stage: stage)
        return true
    }
    
    /**
     Sequenceをスタートさせる
     
     - Parameters:
       - stage: Sceneが乗っかるstageオブジェクト
       - scene: 起動させた際に一番最初に表示させる画面
       - context: sceneを表示させるさいに必要となるcontextオブジェクト
       - invoke: sceneを表示させるのに必要となる処理
     */
    public func startWith<S: Scene>(_ stage: R.StageType,
                                    _ scene: S,
                                    _ context: S.ContextType,
                                    _ invoke: (_ scene: S, _ stage: R.StageType) -> Void) {
        self.stage = stage
        self.scenes.append(HashWrap(scene))
        let hashwrap = HashWrap(scene)
        contextByPage[hashwrap] = context
        containerByScean[hashwrap] = self
        invoke(scene, stage)
    }
    
    /**
     SceneSequenceを生成する
     
     - Parameters:
       - transition:  MEMO ruleという名前の方が良いかも・・・
       - isRecordable: trueがデフォルト。 Scene遷移の履歴を保存するのかのフラグ
                       ここがfalseだと履歴が保存されず、Sceneを実装したクラスの方でprev()を呼んでも何も起きない
     */
    public init(_ rule: R?, _ isRecordable: Bool = true) {
        scenes = [HashWrap]()
        self.rule = rule
        self.isRecordable = isRecordable
    }
}


