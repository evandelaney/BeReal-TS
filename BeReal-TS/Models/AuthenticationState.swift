//
//  Created by Evan DeLaney on 12/16/23.
//

import Foundation

actor AuthenticationState {
    
    enum State {
        case unauthenticated
        case authenticated(User)
        case loading
        case error(Swift.Error)
    }
    
    private(set) var state: State
    
    init(initialState: State = .unauthenticated)
    {
        self.state = initialState
    }
    
    func transition(to nextState: State) throws
    {
        switch (state, nextState) {
        case (.unauthenticated, .unauthenticated), (.unauthenticated, .loading), (.unauthenticated, .error):
            state = nextState
            
        case (.loading, .loading), (.loading, .error), (.loading, .authenticated):
            state = nextState
            
        case (.authenticated, .authenticated), (.authenticated, .unauthenticated):
            state = nextState
            
        case (.error, .error), (.error, .loading):
            state = nextState
            
        default:
            throw StateMachineError.invalidTransition(from: state, to: nextState)
        }
    }
}

extension AuthenticationState.State: Equatable {
    
    static func == (lhs: AuthenticationState.State, rhs: AuthenticationState.State) -> Bool
    {
        switch (lhs, rhs) {
        case (.unauthenticated, .unauthenticated), (.loading, .loading):
            return true
            
        case (.authenticated(let lhsUser), .authenticated(let rhsUser)):
            return lhsUser === rhsUser
            
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
            
        default:
            return false
        }
    }
}
