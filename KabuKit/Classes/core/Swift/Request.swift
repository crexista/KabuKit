import Foundation

open class Request<ContextType> {
    
    public let context: ContextType?
    
    public init(_ context: ContextType) {
        self.context = context
    }
}
