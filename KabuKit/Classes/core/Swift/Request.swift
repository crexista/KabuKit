import Foundation

open class TransitionRequest<ContextType> {
    
    public let context: ContextType?
    
    public init(_ context: ContextType) {
        self.context = context
    }
}
