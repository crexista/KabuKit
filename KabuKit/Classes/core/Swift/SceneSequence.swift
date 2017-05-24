import Foundation

internal var containerByScean = [HashWrap : LinkHandler]()

/**
 複数のSceneを管理し、それぞれからの遷移リクエストを受け付け画面切り替えを行うクラス
 
 - Attention:
 このクラスの `start:` を明示的に呼ばないと内部でのSceneがリクエストしても画面遷移は行われない

 */
public class SceneSequence<C, S: Scenario> : Scene, LinkHandler {

    public typealias ContextType = C
    
    public typealias StageType = S.StageType
    
    private var scenes: [HashWrap]
    
    private var isRecordable: Bool = true
    
    private var scenario: S?
    
    private var stage: S.StageType?
    
    internal func handle<P: Page, T>(_ from: P, _ link: Link<T>) -> Bool {
        // scenario及びstageがセットされていない場合は遷移ができないのでなにもしない
        guard let scenario = self.scenario else { return false }
        guard let stage = self.stage else { return false }
        
        let nextPageRequest = from.requestNextPage(scenario: scenario, link: link)

        nextPageRequest.execute(from: from, stage: stage) { (nextPage) in
            guard self.isRecordable else { return }            
            let hashwrap = HashWrap(nextPage)
            scenes.append(hashwrap)
            containerByScean[hashwrap] = self
        }
        
        return true
    }
    
    internal func back<P: Page>(_ current: P) -> Bool {
        // scenario及びstageがセットされていない場合は遷移ができないのでなにもしない
        guard self.scenario != nil else { return false }
        guard let stage = self.stage else { return false }
        
        // どのようにSceneが積み重ねなれるかのフラグ.
        // isRecordable が flaseの時は保存されてないので戻れない
        guard isRecordable else { return false }
        
        let hashwrap = HashWrap(current)
        _ = scenes.popLast()
        containerByScean.removeValue(forKey: hashwrap)
        
        self.scenario?.onEnd(page: current, stage: stage)
        return true
    }
    
    /**
     Sequenceをスタートさせる
     
     - Parameters:
       - stage: Sceneが乗っかるstageオブジェクト
       - scene: 起動させた際に一番最初に表示させる画面
       - context: sceneを表示させるさいに必要となるcontextオブジェクト
       - setup: sceneを表示させるのに必要となる処理
     */
    public func startWith<T: Scene>(_ stage: S.StageType,
                                    _ scene: T,
                                    _ context: T.ContextType,
                                    _ setup: (_ scene: T, _ stage: S.StageType) -> Void) {
        self.stage = stage
        self.scenes.append(HashWrap(scene))
        scene.context = context
    }
    
    public init(_ scenario: S?) {
        scenes = [HashWrap]()
        self.scenario = scenario
    }
}


