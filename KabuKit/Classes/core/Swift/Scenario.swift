import Foundation

/**
 特定の`Scene`を表示している最中Requestがきたらどの画面にどのように遷移するか、
 そしてどのように画面を戻るか、を規定したクラス
 
 一つのSceneごとにつくられる
 
 */
public class Scenario<CurrentScreenType: Screen, StageType> : TransitionProcedure {
    
    internal typealias Transitioning = (CurrentScreenType, StageType, Any?) -> Void
    
    public typealias Rewind = () -> Void
    
    private var rewind: (() -> Void)?
    
    private let queue: DispatchQueue = DispatchQueue.main
    
    fileprivate var dic = [String : Transitioning]()

    fileprivate var destination: Screen?
    
    fileprivate var current: CurrentScreenType?
    
    fileprivate var stage: StageType?
    
    fileprivate var exitFunc: Rewind?
    
    fileprivate weak var container: SceneContainer?
    
    internal let name: String
    
    public init(_ fromType: CurrentScreenType.Type){
        name = String(reflecting: fromType)
    }
    
    internal func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: TransitionProcedure.Rewind?) {
        self.setup(at: at, on: stage, with: with, when: rewind, {})
    }
    
    internal func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: Rewind?, _ completion: @escaping () -> Void) {
        queue.async {
            guard let c = at as? CurrentScreenType else { return }
            guard let stg = stage as? StageType else { return }
            self.current = c
            self.stage = stg
            self.rewind = rewind
            self.container = with

            completion()
        }
    }
    
    internal func start<ContextType>(at request: Request<ContextType>, _ completion: @escaping (Bool) -> Void) -> Void {
        queue.async {
            guard let frm = self.current else { return }
            guard let stage = self.stage else { return }
            guard let tuple = self.dic[String(describing: request)] else {
                completion(false)
                return
            }
            
            tuple(frm, stage, request.context)
            completion(true)
        }
    }
    
    
    internal func back(_ runRewindHandler: Bool, _ completion: @escaping (Bool) -> Void) {
        queue.async {
            guard let rewind = self.rewind , let current = self.current else {
                completion(false)
                return
            }
            
            if runRewindHandler {
                rewind()
            }

            self.container?.remove(screen: current) {
                completion(true)
            }
        }
    }
}


public extension Scenario where CurrentScreenType : Scene {
    
    public typealias Args<NextSceneType: Scene> = (from: CurrentScreenType, next: NextSceneType, stage: StageType)
    
    public func given<ContextType, NextSceneType: Scene>(_ request: Request<ContextType>.Type,
                      _ to: @escaping () -> NextSceneType,
                      _ begin: @escaping (Args<NextSceneType>) -> Rewind) -> Void where NextSceneType.Context == ContextType {
        
        let requestName = String(reflecting: request)

        let transitFunc = { [weak self](from: CurrentScreenType, stage: StageType, context: Any?) -> Void in
            guard let weakSelf = self else { return }
            let next = to()
            let args = Args<NextSceneType>(from: from, next: next, stage: stage)
            let rewind = begin(args)
            weakSelf.destination = next
            weakSelf.container?.add(screen: next, context: context) {
                rewind()
                weakSelf.destination = nil
            }
        }
        
        dic[requestName] = transitFunc
    }
}
