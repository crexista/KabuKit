import Foundation

/**
 ScreenはProtocolである為、Hashableを実装できずHashのKeyとして利用することができないが、
 このクラスでScreenをwrapすることにより、擬似的にHashのkeyとして利用することができるようになる
 
 */
class ScreenHashWrapper : Hashable {
    
    let hashValue: Int
    
    weak var screen: Screen?
    
    static func ==(lhs: ScreenHashWrapper, rhs: ScreenHashWrapper) -> Bool {
        return (lhs.hashValue == rhs.hashValue)
    }
    
    /**
     Hashableが実装されていないScreenクラスを渡した場合のイニシャライザ
     
     - Parameters
       - screen: Screenを実装したクラスインスタンス
     */
    init(_ screen: Screen) {
        self.screen = screen
        hashValue = Unmanaged<AnyObject>.passUnretained(screen).toOpaque().hashValue
    }
    
}
