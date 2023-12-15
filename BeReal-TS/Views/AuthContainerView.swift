//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct AuthContainerView: View {
    
    @State var viewModel: AuthViewModel
    
    init(client: APIClient, authentication: Authentication)
    {
        _viewModel = State(wrappedValue: AuthViewModel(authentication: authentication, client: client))
    }
    
    var body: some View {
        if viewModel.isAuthenticated {
            if let user = viewModel.authenticatedUser {
                NavigationStack {
                    ItemsView(items: [ user.rootItem ])
                        .navigationTitle(user.firstName)
                        .toolbar(content: {
                            Button("Log Out", systemImage: "door.left.hand.open") {
                                viewModel.logOut()
                            }
                        })
                }
                
            }
            else {
                ProgressView()
                    .onAppear {
                        Task {
                            await viewModel.reloadUser()
                        }
                    }
            }
        }
        else {
            LoginView(viewModel: viewModel)
        }
    }
}

#Preview {
    let auth = Authentication()
    let client = APIClient(hostname: "", urlSession: URLSession.shared)
    
    return AuthContainerView(client: client, authentication: auth)
}
