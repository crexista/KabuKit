import Foundation

/**
 特定の`Scene`を表示している最中Requestがきたらどの画面にどのように遷移するか、
 そしてどのように画面を戻るか、を規定したクラス
 
 一つのSceneごとにつくられる
 
 */
public class Scenario<Current: Screen, Stage> : Transition {
    
    internal typealias Transitioning = (Current, Stage, Any?) -> Void
    
    public typealias Rewind = () -> Void
    
    private var rewind: (() -> Void)?
    
    private let queue: DispatchQueue = DispatchQueue.main
    
    fileprivate var dic = [String : Transitioning]()

    fileprivate var destination: Screen?
    
    fileprivate var current: Current?
    
    fileprivate var stage: Stage?
    
    fileprivate var exitFunc: Rewind?
    
    fileprivate weak var container: SceneContainer?
    
    internal let name: String
    
    public init(_ fromType: Current.Type){
        name = String(reflecting: fromType)
    }
    
    internal func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: Transition.Rewind?) {
        self.setup(at: at, on: stage, with: with, when: rewind, {})
    }
    
    internal func setup<S>(at: Screen, on stage: S, with: SceneContainer, when rewind: Rewind?, _ completion: @escaping () -> Void) {
        queue.async {
            guard let c = at as? Current else { return }
            guard let stg = stage as? Stage else { return }
            self.current = c
            self.stage = stg
            self.rewind = rewind
            self.container = with

            completion()
        }
    }
    
    internal func start<T>(at request: Request<T>, _ completion: @escaping (Bool) -> Void) -> Void {
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
    
    
    internal func back(_ completion: @escaping (Bool) -> Void) {
        queue.async {
            guard let rewind = self.rewind , let current = self.current else {
                completion(false)
                return
            }
            
            rewind()
            self.container?.remove(screen: current) {
                completion(true)
            }
        }
    }
}


public extension Scenario where Current : Scene {
    
    public typealias Args<Next: Scene> = (from: Current, next: Next, stage: Stage)
    
    public func given<ContextType, Next: Scene>(_ request: Request<ContextType>.Type,
                      _ to: @escaping () -> Next,
                      _ begin: @escaping (Args<Next>) -> Rewind) -> Void where Next.ContextType == ContextType {
        
        let requestName = String(reflecting: request)

        let transitFunc = { [weak self](from: Current, stage: Stage, context: Any?) -> Void in
            guard let weakSelf = self else { return }
            let next = to()
            let args = Args<Next>(from: from, next: next, stage: stage)
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
