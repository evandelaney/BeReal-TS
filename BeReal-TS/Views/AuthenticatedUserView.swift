//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct AuthenticatedUserView: View {
    
    let viewModel: AuthenticatedUserViewModel
    
    var body: some View {
        ItemsView(items: [ viewModel.root ] )
            .navigationTitle(viewModel.fullName)
            .toolbar {
                Button("Log Out", systemImage: "rectangle.portrait.and.arrow.right") {
                    Task {
                        await viewModel.logOut()
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        AuthenticatedUserView(
            viewModel: .preview1
        )
    }
}
