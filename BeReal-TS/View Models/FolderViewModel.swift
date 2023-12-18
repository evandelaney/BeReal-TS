//
//  Created by Evan DeLaney on 12/17/23.
//

import Observation
import PhotosUI

@Observable
final class FolderViewModel {
    
    private(set) var state: FolderState.State
    
    var items: [ any Item ]? {
        if case let .content(items) = state {
            return items
        }
        return nil
    }
    
    var error: Error? {
        if case let .error(error) = state {
            return error
        }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var isEmpty: Bool {
        if case .empty = state {
            return true
        }
        return false
    }
    
    let client: APIClient
    
    let root: Folder
    
    private var stateMachine: FolderState
    
    init(client: APIClient, root: Folder)
    {
        self.client = client
        self.root = root
        self.stateMachine = FolderState(initialState: .empty)
        self.state = .empty
        
        Task {
            await loadItems()
        }
    }
    
    func createFolder(name: String) async
    {
        // TODO: Needs implementation
    }
    
    func createFile(name: String, image: UIImage) async
    {
        // TODO: Needs implementation
    }
    
    private func loadItems() async
    {
        do {
            await stateMachineTransition(to: .loading)
            let items = try await client.getItems(at: root)
            let newState = if items.count > 0 {
                FolderState.State.content(items)
            }
            else {
                FolderState.State.empty
            }
            await stateMachineTransition(to: newState)
        }
        catch {
            await stateMachineTransition(to: .error(error))
        }
    }
    
    private func stateMachineTransition(to newState: FolderState.State) async
    {
        do {
            try await stateMachine.transition(to: newState)
            await MainActor.run {
                state = newState
            }
        }
        catch {
            print(error)
            fatalError()
        }
    }
}
