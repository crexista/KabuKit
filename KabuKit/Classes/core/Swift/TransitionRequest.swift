import Foundation

open class TransitionRequest<ContextType, ExpectedResultType> {
    
    public let context: ContextType
    
    public let callback: (ExpectedResultType?) -> Void
    
    public init(_ context: ContextType, whenRewind: @escaping (ExpectedResultType?) -> Void) {
        self.context = context
        self.callback = whenRewind
    }
}


public extension TransitionRequest where ExpectedResultType == Void {

    public convenience init(_ context: ContextType) {
        self.init(context) { (value) in

        }
    }
}

public extension TransitionRequest where ContextType == Void {
    
    public convenience init(_ rewind: @escaping (ExpectedResultType?) -> Void) {
        self.init((), whenRewind: rewind)
    }
}

