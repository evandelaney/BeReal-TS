//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct AuthenticatedNavigationStack<Content: View>: View {
    
    var contentView: () -> Content
    
    let factory: ViewModelFactory
    
    @State private var path = NavigationPath()
    
    init(
        factory: ViewModelFactory,
        path: NavigationPath = .init(),
        @ViewBuilder contentView: @escaping () -> Content
    ) {
        self.contentView = contentView
        self.factory = factory
        self.path = path
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            contentView()
                .navigationDestination(for: Folder.self) { folder in
                    FolderView(viewModel:
                                factory.makeFolderViewModel(from: folder)
                    )
                }
                .navigationDestination(for: File.self) { file in
                    FileView()
                }
        }
    }
}

struct FileView: View {
    
    var body: some View {
        Text("File View")
    }
}
