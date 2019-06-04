//
//  Copyright © 2017 crexista
//

import Foundation

/**
 画面を切り替える手順を示したプロトコル

 */
protocol TransitionProcedure : class {
    
    typealias Rewind = () -> Void
       
    func start<ContextType, ExpectedResult, ScreenType: Screen>(atRequestOf request: TransitionRequest<ContextType, ExpectedResult>,
                                                                from screen: ScreenType,
                                                                _ completion: @escaping (Bool) -> Void) -> Void
}
