import Foundation

public protocol SequenceRule : class {
    
    associatedtype StageType
    
    var scenario: Scenario<StageType> { get }
    
    func onEnd<S: Page>(page: S, stage: StageType)
}
