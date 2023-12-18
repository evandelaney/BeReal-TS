//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

actor FolderState {
    
    enum State {
        case content([ any Item ])
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

extension FolderState.State: Equatable {
    
    // Can cost O(n) in worst case
    static func == (lhs: FolderState.State, rhs: FolderState.State) -> Bool
    {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading):
            return true

        case (.content(let lhsItems), .content(let rhsItems)):
            guard lhsItems.count == rhsItems.count else { return false }
            for (index, item) in lhsItems.enumerated() {
                if lhsItems[index].identifier != rhsItems[index].identifier {
                    return false
                }
            }
            return true

        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription

        default:
            return false
        }
    }
}
