//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct AuthContainerView: View {
    
    @State var viewModel: AuthenticationViewModel
    
    let factory: ViewModelFactory
    
    init(factory: ViewModelFactory = globalViewModelFactory)
    {
        self.factory = factory
        viewModel = self.factory.makeAuthenticationViewModel()
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
