import Foundation

open class Link<ContextType> {
    
    public let context: ContextType?
    
    init(_ context: ContextType) {
        self.context = context
    }
}
