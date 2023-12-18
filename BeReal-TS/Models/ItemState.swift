//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

actor ItemState<T> {
    
    enum State {
        case content(T)
        case empty
        case loading
        case error(Swift.Error)
    }
    
    private(set) var state: State
    
    init(initialState: State = .empty)
    {
        self.state = initialState
    }
    
    func transition(to nextState: State) throws
    {
        switch (state, nextState) {
        case (.empty, .empty), (.empty, .loading):
            state = nextState
            
        case (.content, .content), (.content, .loading):
            state = nextState
            
        case (.loading, .loading), (.loading, .empty), (.loading, .content), (.loading, .error):
            state = nextState
            
        case (.error, .error), (.error, .loading):
            state = nextState
            
        default:
            throw StateMachineError.invalidTransition(from: state, to: nextState)
        }
    }
}

extension ItemState.State: Equatable where T:Equatable {
    
    static func == (lhs: ItemState.State, rhs: ItemState.State) -> Bool
    {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading):
            return true
            
        case (.content(let lhsItems), .content(let rhsItems)):
            return lhsItems == rhsItems
            
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
            
        default:
            return false
        }
    }
}
