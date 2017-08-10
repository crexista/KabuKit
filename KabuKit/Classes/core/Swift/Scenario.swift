import Foundation

/**
 特定の`Scene`を表示している最中Requestがきたらどの画面にどのように遷移するか、
 そしてどのように画面を戻るか、を規定したクラス
 
 一つのSceneごとにつくられる
 
 */
public class Scenario<CurrentScreenType: Screen, StageType> : TransitionProcedure {

    public typealias Rewind = () -> Void
    
    private let dispatchQueue: DispatchQueue = DispatchQueue.main
    
    fileprivate var transitionStore = [String : Transition<CurrentScreenType>]()
    
    fileprivate var stage: StageType?
    
    fileprivate weak var iterator: SceneIterator?
    
    internal let name: String
    
    init(_ fromType: CurrentScreenType.Type, _ iterator: SceneIterator, _ stage: StageType){
        name = String(reflecting: fromType)
        self.iterator = iterator
        self.stage = stage
    }


    
    internal func start<ContextType, ExpectedResult>(from current: Screen,
                                     at request: TransitionRequest<ContextType, ExpectedResult>,
                                     _ completion: @escaping (Bool) -> Void) -> Void {
        self.doStart(from: current as! CurrentScreenType, at: request, completion)
    }
    
    
    func doStart<ContextType, ExpectedResult>(from current: CurrentScreenType,
                 at request: TransitionRequest<ContextType, ExpectedResult>,
               _ completion: @escaping (Bool) -> Void) -> Void {
        dispatchQueue.async {
            guard let stage = self.stage else { return }
            guard let transition = self.transitionStore[String(describing: request)] else {
                completion(false)
                return
            }
            transition.start(from: current, on: stage, with: request)
            completion(true)
        }
    }

}


public extension Scenario where CurrentScreenType : Scene {
    
    public typealias Args<NextSceneType: Scene> = (from: CurrentScreenType, next: NextSceneType, stage: StageType)
    
    public func given<ContextType, ExpectedResult, NextSceneType: Scene>(_ request: TransitionRequest<ContextType, ExpectedResult>.Type,
                                                                         transitTo next: @escaping () -> NextSceneType,
                                                                         with transition: @escaping (Args<NextSceneType>) -> Rewind) -> Void
                                                                         where NextSceneType.Context == ContextType,
                                                                               NextSceneType.ReturnValue == ExpectedResult {
        
        let requestName = String(reflecting: request)
        let transitioning = { (from: CurrentScreenType, next: NextSceneType, stage: Any) -> () -> Void in
            let args = Args<NextSceneType>(from: from, next: next, stage: stage as! StageType)
            return transition(args)
        }

        let transition = Transition(to: next, iterator: self.iterator!, with: transitioning)
        transitionStore[requestName] = transition
    }
}

