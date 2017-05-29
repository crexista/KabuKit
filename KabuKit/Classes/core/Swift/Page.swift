import Foundation


public protocol Page : class {
    
    /**
     リンク先に遷移する
     
     - Attention:
     指定リンク先がなにであるかはSequenceRule側で指定しておく必要がある
     
     それを忘れるとこのメソッドを呼んでもなにも起きない  

     
     - Parameters:
       - link: 遷移先へのリンク
     
     - Returns: リンク先が存在し、遷移できたかどうかを返す
     
     */
    @discardableResult
    func jumpTo<T>(_ link: Link<T>) -> Bool
    
    /**
     現在表示されているSceneを終了させ、前のSceneに戻る
     
     - Attention :
     ただし、前のシーンがない場合は戻らず、何も起きない
     
     - Returns: 戻れるかどうかの成否
     前のシーンがなかったりして戻れなかった場合はfalseを返す
     
     */
    @discardableResult
    func prev() -> Bool
}

extension Page {

    internal var handler: LinkHandler? {

        return containerByScean[HashWrap(self)]
    }
    
    @discardableResult
    public func prev() -> Bool {
        guard let handler = self.handler else { return false }
        return handler.back(self)
    }
    
    @discardableResult
    public func jumpTo<T>(_ link: Link<T>) -> Bool {
        guard let handler = self.handler else { return false }
        return handler.handle(self, link)
    }

}


