import Foundation

fileprivate var suspendCallback: [ScreenHashWrapper : () -> Void] = [ScreenHashWrapper : () -> Void]()
fileprivate var resumeCallback: [ScreenHashWrapper : () -> Void] = [ScreenHashWrapper : () -> Void]()

fileprivate var screenBehaviorContainer: [ScreenHashWrapper: ScreenBehavior] = [ScreenHashWrapper: ScreenBehavior]()

/**
 表示される画面のProtocolです
 
 */
public protocol Screen : class {
    
    
    var isSuspended: Bool { get }
        
    /**
     画面がサスペンド状態になった際に呼ばれます
     
     */
    func onSuspend() -> Void
    
    /**
     画面がアクティブ状態になった際に呼ばれます
     
     */
    func onActivate() -> Void
}

public extension Screen {
    public var isSuspended: Bool {
        guard let behavior = screenBehaviorContainer[ScreenHashWrapper(self)] else {
            return true
        }
        return behavior.isSuspended
    }
}

extension Screen {

    
    var behavior: ScreenBehavior? {
        return screenBehaviorContainer[ScreenHashWrapper(self)]
    }
    
    internal func registerOnSuspend(f:(() -> Void)?) {
        suspendCallback[ScreenHashWrapper(self)] = f
    }
    
    internal func registerOnResume(f: (() -> Void)?) {
        resumeCallback[ScreenHashWrapper(self)] = f
    }
    
    internal func registerBehavior(behavior: ScreenBehavior) {
        screenBehaviorContainer[ScreenHashWrapper(self)] = behavior
    }
    

    public func onSuspend() -> Void {
        suspendCallback[ScreenHashWrapper(self)]?()
    }
    
    public func onActivate() -> Void {
        resumeCallback[ScreenHashWrapper(self)]?()
    }

}

class ScreenBehavior {
    typealias  Callback = () -> Void
    let onSuspend: Callback?
    let onActivate: Callback?
    var isStarted: Bool = false
    var isSuspended: Bool = false
    
    init(isStarted: Bool = false, isSuspended:Bool = false, onSuspend: Callback? = nil, onActivate: Callback? = nil) {
        self.isStarted = isStarted
        self.isSuspended = isSuspended
        self.onSuspend = onSuspend
        self.onActivate = onActivate
    }
}
