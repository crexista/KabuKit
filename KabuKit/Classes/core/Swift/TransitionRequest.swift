import Foundation

open class TransitionRequest<Context, ReturnValue> {
    
    public let context: Context
    public let callback: (ReturnValue) -> Void
    
    public required init(_ context: Context, whenRewind: @escaping (ReturnValue) -> Void) {
        self.context = context
        self.callback = whenRewind
    }
}

public extension TransitionRequest where ReturnValue == Void {

    public convenience init(_ context: Context) {
        self.init(context) { (value) in

        }
    }
}

public extension TransitionRequest where Context == Void {
    
    public convenience init(_ rewind: @escaping (ReturnValue) -> Void) {
        self.init((), whenRewind: rewind)
    }
}

