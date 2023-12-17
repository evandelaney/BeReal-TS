//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct AuthContainerView: View {
    
    @State var viewModel: AuthenticationViewModel
    
    init(client: APIClient, authentication: Authentication)
    {
        _viewModel = State(wrappedValue: AuthenticationViewModel(authentication: authentication, client: client))
    }
    
    var body: some View {
        
        if let user = viewModel.authenticatedUser {
            NavigationStack {
                ItemsView(items: [ user.rootItem ])
                    .navigationTitle(user.firstName)
                    .toolbar(content: {
                        Button("Log Out", systemImage: "door.left.hand.open") {
                            Task {
                                await viewModel.logOut()
                            }
                        }
                    })
            }
        }
        else {
            LoginView(viewModel: viewModel)
        }
    }
}
