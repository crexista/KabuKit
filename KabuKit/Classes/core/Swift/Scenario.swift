import Foundation

public protocol Scenario : class {
    
    associatedtype StageType: AnyObject
    
    func routing(router: Router<StageType>)
    
    func onEnd<S: Page>(page: S, stage: StageType)
}
