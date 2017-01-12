//
//  Copyright © 2017 crexista
//

import Foundation

struct ActionError: Error {
    let recoverPattern: RecoverPattern
    let target: ActionEvent
    let onError: (Error, String?) -> RecoverPattern
    let actionName: String
}
