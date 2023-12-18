//
//  FolderView.swift
//  BeReal-TS
//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct FolderView: View {
    
    @State var viewModel: ItemViewModel<Folder, [ any Item ]>
    
    var body: some View {
        if let items = viewModel.items {
            ItemsView(items: items)
        }
        else if let error = viewModel.error {
            VStack {
                Text("⚠️ Error:")
                    .foregroundStyle(.red)
                    .font(.largeTitle)
                Text(error.localizedDescription)
            }
            .padding()
        }
        else if viewModel.isLoading {
            ProgressView {
                Text("Loading...")
            }
        }
        else if viewModel.isEmpty {
            VStack {
                Text("Nothing here.")
                    .font(.title)
                Text("Why don't you add something?")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                    
            }
            .padding()
        }
    }
}

#Preview {
    FolderView(
        viewModel: ItemViewModel(
            root: Folder.preview1,
            getter: globalClient.getItems(at:)
        )
    )
}
