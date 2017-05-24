import Foundation

public class Router<Stage> {
    
//    public typealias Stage = ScenarioType.StageType
    
    private var route: [String : SceneRequest<Stage>]?
    
    public init(){
        route = [String : SceneRequest<Stage>]()

    }
    
    /**
     Routerにrouting ruleを追加する
     
     */
    public func add<T: Scene>(_ from: Page.Type,
                              _ link: Link<T.ContextType>.Type,
                              to: T,
                              start: @escaping (_ from: Page, _ to: T, _ stage: Stage) -> Void = { _ in }) {
        
        let name = String(describing: link)
        let invokeFunc = { to }
        route?[name] = SceneRequest<Stage>(invokeFunc: invokeFunc, startFunc: start)
    }
    
    /**
     Routerにrouting ruleを追加する
     */
    public func add<S: Scene>(_ from: Page.Type,
                              _ link: Link<S.ContextType>.Type,
                              to: @escaping () -> S,
                              start: @escaping (_ from: Page, _ to: S, _ stage: Stage) -> Void = { _ in }) {

        let name = String(describing: link)
        route?[name] = SceneRequest<Stage>(invokeFunc: to, startFunc: start)
    }
    
    internal func resolve<T>(link: Link<T>, current: Page) -> SceneRequest<Stage> {
        let name = String(describing: type(of: link))
        return (route?[name])!
    }
        
}

/**
 
 */
class SceneRequest<Stage> {
    
    private let runFunc: (_ stage: Stage, _ from: Page, _ prepare: (Page) -> Void) -> Void
    
    func execute(from: Page, stage: Stage, prepare: (Page) -> Void) {
        runFunc(stage, from, prepare)
    }
    
    /**
     TODO: 後で引数にfromとしてPageをついか
     
     */
    init<To: Scene>(invokeFunc: @escaping () -> To, startFunc: @escaping (Page, To, Stage) -> Void) {
        runFunc = { (stage: Stage, from: Page, prepare: (Page) -> Void) -> Void in
            let to: To = invokeFunc()
            prepare(to)
            startFunc(from, to, stage)
        }
    }
}
