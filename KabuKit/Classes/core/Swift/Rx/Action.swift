//
//  Copyright © 2017 crexista
//

import Foundation

// NOTE ここら辺を同じファイルにまとめておかないとSegment fault が起きる


public protocol Action : SignalClosable {
    
    associatedtype SceneType: Scene
    
    associatedtype DestinationType: Destination
    
    func invoke(director: Director<DestinationType>) -> [ActionEvent]
    
    /**
     このActionのInvoke内で起動させたSignalの中で一つでもキャッチし損ねたエラーが発生したらこのメソッドが呼ばれます.
     
     - parameters:
       - error: キャッチし損ねたエラーのクラスです.
       - label: エラーを起こしたシグナルの名前です. 
                設定している場合のみ取得できます. 設定していない場合は取得できません.
     */
    func onError(error: Error, label: String?) -> RecoverPattern
}

public extension Action where Self.DestinationType == SceneType.RouterType.DestinationType {}

public protocol SignalClosable {
    
    func onStop()
}

/**
 ActionのInvoke時にSubscribeされたシグナルの中でエラーが起きたさい、このActionErrorにラップされます
 
 */
internal struct ActionError<A: Action>: Error {
    public let from: A
    public let event: ActionEvent
    public let cause: Error
}

