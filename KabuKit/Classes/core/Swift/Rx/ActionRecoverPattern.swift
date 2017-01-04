//
//  Copyright © 2017年 crexista
//

import Foundation

/**
 Errorが起きてcatchできずにActionで拾った際に行われる
 Recover処理の種類です
 
 */
public enum ActionRecoverPattern {
    // 何もしません.
    // subscribeも切れるのでなにも反応が無くなります
    case doNothing
    
    // エラーが起きたAction自体をリロードします
    case reloadAction(onStart: () -> Void)
    
    // エラーが起きたSignalのみをリロードしますa
    case reloadErrorStream(onStart: () -> Void)
}
