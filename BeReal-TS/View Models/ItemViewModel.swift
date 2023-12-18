//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation
import Observation

protocol EmptyRepresentable {
    
    var isEmpty: Bool { get }
}

extension Array: EmptyRepresentable { }

extension Data: EmptyRepresentable { }

@Observable
final class ItemViewModel<Root: Item, Detail: EmptyRepresentable> {
    
    private(set) var state: ItemState<Detail>.State
    
    var items: Detail? {
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
    
    var getter: (Root) async throws -> Detail
    
    var canCreateFolder: Bool {
        folderCreator != nil
    }
    
    var folderCreator: ((Root, String) async throws -> Detail)?
    
    var canCreateImage: Bool {
        imageCreator != nil
    }
    
    var imageCreator: ((Root, String, Data) async throws -> Detail)?
    
    let root: Root
    
    private var stateMachine: ItemState<Detail>
    
    init(
        root: Root,
        getter: @escaping (Root) async throws -> Detail,
        imageCreator: ((Root, String, Data) async throws -> Detail)? = nil,
        folderCreator: ((Root, String) async throws -> Detail)? = nil
    ) {
        self.root = root
        self.getter = getter
        self.folderCreator = folderCreator
        self.imageCreator = imageCreator
        self.stateMachine = ItemState(initialState: .empty)
        self.state = .empty
        
        Task {
            await load()
        }
    }
    
    func load() async
    {
        await process(input: root, action: getter)
    }
    
    func createFolder(name: String) async
    {
        guard let folderCreator else { return }
        await process(input: (root, name), action: folderCreator)
    }
    
    func createImage(name: String, data: Data) async
    {
        guard let imageCreator else { return }
        await process(input: (root, name, data), action: imageCreator)
    }
    
    private func process<T>(input: T, action: (T) async throws -> Detail) async
    {
        do {
            await stateMachineTransition(to: .loading)
            let items = try await action(input)
            let newState = if items.isEmpty != true {
                ItemState<Detail>.State.content(items)
            }
            else {
                ItemState<Detail>.State.empty
            }
            await stateMachineTransition(to: newState)
        }
        catch {
            await stateMachineTransition(to: .error(error))
        }
    }
    
    private func stateMachineTransition(to newState: ItemState<Detail>.State) async
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
