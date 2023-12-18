//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct ItemEmptyView<Root: Item, Detail: EmptyRepresentable>: View {
    
    @State var viewModel: ItemViewModel<Root, Detail>
    @State private var isShowingDialog = false
    @State private var newFolder: String = ""
    
    var body: some View {
        VStack {
            Text("Nothing here.")
                .font(.title)
            Text("Why don't you add something?")
                .foregroundStyle(.secondary)
                .font(.headline)
            HStack {
                if viewModel.canCreateFolder {
                    Button("Create Folder") {
                        isShowingDialog = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                if viewModel.canCreateImage {
                    Button("Upload Image") {
                        print("do the needful")
                    }
                    .buttonStyle(.bordered)
                    .padding()
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
    }
    
    private func createFolder()
    {
        Task {
            await viewModel.createFolder(name: newFolder)
        }
    }
}

#Preview {
    ItemEmptyView(viewModel:
                    ItemViewModel(
                        root: Folder.preview1,
                        getter: globalClient.getItems(at:),
                        imageCreator: nil,
                        folderCreator: nil
                    )
    )
}
