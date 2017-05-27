import Foundation

open class Link<ContextType> {
    
    public let context: ContextType?
    
    public init(_ context: ContextType) {
        self.context = context
    }
}
