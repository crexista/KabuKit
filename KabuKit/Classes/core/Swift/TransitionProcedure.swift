//
//  Copyright © 2017 crexista
//

import Foundation

/**
 画面を切り替える手順を示したプロトコル

 */
protocol TransitionProcedure : class {
    
    typealias Rewind = () -> Void
       
    /**
     TransitionProcedureを実行する
     
     - Parameters: 
       - request: aa
       - completion: Transtionの実行が完了した際に実行したい処理
       - setup: completionより前に呼ばれる
     */
    func start<ContextType, ExpectedResult>(from current: Screen,
                                            at request: TransitionRequest<ContextType, ExpectedResult>,
                                            _ completion: @escaping (Bool) -> Void) -> Void
}
