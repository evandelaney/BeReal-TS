//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct AuthenticatedNavigationStack<Content: View>: View {
    
    var contentView: () -> Content
    
    @State private var path = NavigationPath()
    
    init(
        @ViewBuilder contentView: @escaping () -> Content,
        path: NavigationPath = .init()
    ) {
        self.contentView = contentView
        self.path = path
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            contentView()
                .navigationDestination(for: Folder.self) { folder in
                    FolderView()
                }
                .navigationDestination(for: File.self) { file in
                    FileView()
                }
        }
    }
}

struct FolderView: View {
    
    var body: some View {
        Text("Folder View")
    }
}

struct FileView: View {
    
    var body: some View {
        Text("File View")
    }
}
