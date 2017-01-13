//
//  Copyright © 2017 crexista
//

import Foundation

protocol ActionSignal {
    
    var label: String? { get }
    
    var isRunning: Bool { get }
    
    func dispose()
    
    func start<A: Action>(action: A, event: ActionEvent, recoverHandler: @escaping (ActionError<A>, RecoverPattern) -> Void)
}


public class ActionEvent {
    
    private let signal: ActionSignal
    
    public var label: String? {
        return signal.label
    }
    
    internal var isRunning: Bool {
        return signal.isRunning
    }
    
    internal func dispose() {
        signal.dispose()
    }
    
    internal func start<A: Action>(action: A, recoverHandler: @escaping (ActionError<A>, RecoverPattern) -> Void) {
        signal.start(action: action, event: self, recoverHandler: recoverHandler)
    }
    
    init(_ signal: ActionSignal) {
        self.signal = signal
    }
}
