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
    
    fileprivate var dic = [String : (transitioning: Transitioning, back: Rewind)]()

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
            
            tuple.transitioning(frm, stage, request.context)
            completion(true)
        }
    }
    
    
    internal func back(_ completion: @escaping (Bool) -> Void) {
        queue.async {
            self.rewind?()
            completion(true)
        }
    }
}


public extension Scenario where Current : Scene {
    
    public typealias Args<Next: Scene> = (from: Current, next: Next, stage: Stage)
    
    public func given<ContextType, Next: Scene>(link: Request<ContextType>.Type,
                      to: @escaping () -> Next,
                      begin: @escaping (Args<Next>) -> Void,
                      end: @escaping (Args<Next>) -> Void) -> Void where Next.ContextType == ContextType {
        
        let linkName = String(reflecting: link)
        
        let exitFunc = {
            guard let stage = self.stage else { return }
            guard let current = self.current else { return }
            guard let next = self.destination as? Next else { return }

            let args = Args<Next>(from: current, next: next, stage: stage)
            end(args)
            self.destination = nil
        }

        let transitFunc = { (from: Current, stage: Stage, context: Any?) in
            guard let exitFunc = self.exitFunc else { return }
            
            let next = to()
            let args = Args<Next>(from: from, next: next, stage: stage)
            self.destination = next
            self.container?.add(screen: next, context: context, rewind: exitFunc)
            begin(args)
        }
        
        self.exitFunc = exitFunc
        dic[linkName] = (transitFunc, exitFunc)
    }
}

public extension Scenario where Current : AnyTransition {
    
    public typealias Args2<Next: Scene> = (next: Next, stage: Stage)

    public func given<ContextType, Next: Scene>(link: Request<ContextType>.Type,
                      to: @escaping () -> Next,
                      begin: @escaping (Args2<Next>) -> Void,
                      end: @escaping (Args2<Next>) -> Void) -> Void where Next.ContextType == ContextType {
        
        let linkName = String(reflecting: link)
        
        let exitFunc = {
            guard let stage = self.stage else { return }
            guard let next = self.destination as? Next else { return }
            
            let args = Args2<Next>(next: next, stage: stage)
            end(args)
        }
        
        let transitFunc = { (from: Current, stage: Stage, context: Any?) in
            guard let exitFunc = self.exitFunc else { return }
            
            let next = to()
            let args = Args2<Next>(next: next, stage: stage)
            self.destination = next
            self.container?.add(screen: next, context: context, rewind: exitFunc)
            begin(args)
        }

        self.exitFunc = exitFunc
        dic[linkName] = (transitFunc, exitFunc)
    }
}
