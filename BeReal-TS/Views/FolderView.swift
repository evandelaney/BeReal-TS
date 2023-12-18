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
            ItemErrorView(error: error)
                .padding()
        }
        else if viewModel.isLoading {
            ItemLoadingView()
                .padding()
        }
        else if viewModel.isEmpty {
            ItemEmptyView()
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
