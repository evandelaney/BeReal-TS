//
//  FolderView.swift
//  BeReal-TS
//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct FolderView: View {
    
    @State var viewModel: ItemViewModel<Folder, [ any Item ]>
    @State private var isShowingDialog = false
    @State private var newFolder: String = ""
    
    var body: some View {
        if let items = viewModel.items {
            ItemsView(items: items)
                .navigationTitle(viewModel.root.name)
                .toolbar {
                    if viewModel.canCreateFolder {
                        Button("Create Folder", systemImage: "folder.badge.plus") {
                            isShowingDialog = true
                        }
                    }
                }
                .alert("New Folder",
                       isPresented: $isShowingDialog,
                       actions: {
                    TextField("", text: $newFolder)
                    Button("OK", action: createFolder)
                    Button("Cancel", role: .cancel) { }
                },
                       message: {
                    Text("Enter a name for the new folder.")
                })
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
            ItemEmptyView(viewModel: viewModel)
                .padding()
        }
    }
    
    func createFolder()
    {
        Task {
            await viewModel.createFolder(name: newFolder)
        }
    }
}

#Preview {
    FolderView(
        viewModel: ItemViewModel(
            root: Folder.preview1,
            getter: globalClient.getItems(at:),
            imageCreator: nil,
            folderCreator: nil
        )
    )
}
