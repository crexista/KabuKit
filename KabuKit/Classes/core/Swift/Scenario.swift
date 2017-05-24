import Foundation

public protocol Scenario : class {
    
    associatedtype StageType: AnyObject
    
    func routing(router: Router<StageType>)
    
    func onEnd<S: Scene>(scene: S, stage: StageType)
}

extension Page where Self: Scenario {
    
    internal func requestNextPage<S: Scenario, T>(scenario: S, link: Link<T>) -> SceneRequest<S.StageType> where StageType == S.StageType{
        let router = Router<Self.StageType>()
        self.routing(router: router)
        return router.resolve(link: link, current: self)
    }
    
    @discardableResult
    public func jumpTo<T>(_ link: Link<T>) -> Bool {
        self.handler?.handle(self, link)
        return true
    }

    
}
