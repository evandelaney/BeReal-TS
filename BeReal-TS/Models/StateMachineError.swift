//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

enum StateMachineError<State>: Swift.Error {
    
    case invalidTransition(from: State, to: State)
}
