import Foundation


public protocol Page : class {
    
    @discardableResult
    func jumpTo<T>(_ link: Link<T>) -> Bool
    
    /**
     現在表示されているSceneを終了させ、前のSceneに戻る
     
     - Attention :
     ただし、前のシーンがない場合は戻らず、何も起きない
     
     - Returns: 戻れるかどうかの成否。
     前のシーンがなかったりして戻れなかった場合はfalseを返す
     
     */
    @discardableResult
    func prev() -> Bool
}

extension Page {

    internal var handler: LinkHandler? {
        return containerByScean[HashWrap(self)]
    }

    
    internal func requestNextPage<S: Scenario, T>(scenario: S, link: Link<T>) -> SceneRequest<S.StageType> {
        let router = Router<S.StageType>()
        scenario.routing(router: router)
        return router.resolve(link: link, current: self)
    }
    
    @discardableResult
    public func prev() -> Bool {
        return true
    }
    
    @discardableResult
    public func jumpTo<T>(_ link: Link<T>) -> Bool {
        self.handler?.handle(self, link)
        return true
    }

}


