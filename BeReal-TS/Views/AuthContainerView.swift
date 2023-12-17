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
        if let viewModel = factory.makeAuthenticatedUserViewModel(from: viewModel) {
            AuthenticatedNavigationStack(factory: factory) {
                AuthenticatedUserView(viewModel: viewModel)
            }
        }
        else {
            LoginView(viewModel: viewModel)
        }
    }
}
