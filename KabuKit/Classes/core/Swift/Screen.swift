import Foundation

fileprivate var suspendCallback: [ScreenHashWrapper : () -> Void] = [ScreenHashWrapper : () -> Void]()
fileprivate var resumeCallback: [ScreenHashWrapper : () -> Void] = [ScreenHashWrapper : () -> Void]()

public protocol Screen : class {
    
    func onSuspend() -> Void
    
    func onResume() -> Void
}

extension Screen {

    internal func registerOnSuspend(f:(() -> Void)?) {
        suspendCallback[ScreenHashWrapper(self)] = f
    }
    
    internal func registerOnResume(f: (() -> Void)?) {
        resumeCallback[ScreenHashWrapper(self)] = f
    }

    public func onSuspend() -> Void {
        suspendCallback[ScreenHashWrapper(self)]?()
    }
    
    public func onResume() -> Void {
        resumeCallback[ScreenHashWrapper(self)]?()
    }

}
