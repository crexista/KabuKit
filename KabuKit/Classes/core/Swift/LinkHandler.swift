import Foundation

internal protocol LinkHandler {
    
    /**
     指定のPageからのリンクをハンドルしてSequenceRuleに指定されている画面へと遷移させる

     - Parameters:
       - from: リンク元の画面
       - link: リンク
     - Returns: リンク先が存在し、遷移できたか否か
     */
    func handle<P: Page, T>(_ from: P, _ link: Link<T>) -> Bool
    
    /**
     前の画面に戻る
     
     - Attention:
     一番最初の画面だったりしたために前の画面が存在しない場合はこのメソッドを呼んでも
     
     なにも起きない(戻ることができない)
     
     - Paramerters:
       - current: 現在表示中の画面
     
     - Returns: 戻り先が存在し戻ることができた場合は true を返す
     */
    func back<P: Page>(_ current: P) -> Bool

}
