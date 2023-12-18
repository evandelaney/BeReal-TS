//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct LoginView: View {
    
    var viewModel: AuthenticationViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        VStack{
            Spacer()
            
            VStack{
                if case .loading = viewModel.state {
                    loading
                }
                else {
                    credentialForm
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            
            Spacer()
            
            Button("Log In") {
                Task {
                    await viewModel.logIn(username: username, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                username.isEmpty ||
                password.isEmpty ||
                viewModel.state == .loading
            )
            .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
    
    @ViewBuilder
    @MainActor
    var credentialForm: some View {
        Text("Welcome!")
            .font(.title)
            .padding(.vertical)
        
        
        LabeledTextField(
            text: $username,
            labelText: "Username",
            textFieldHint: "TheRealEvan555")
        
        LabeledTextField(
            text: $password,
            isSecure: true,
            labelText: "Password",
            textFieldHint: "password123"
        )
        
        if let error = viewModel.error {
            Text("Error: \(error.localizedDescription)")
                .font(.caption)
                .foregroundStyle(Color.red)
        }
    }
    
    @ViewBuilder
    @MainActor
    var loading: some View {
        HStack {
            Spacer()
            
            ProgressView {
                Text("Loading...")
            }
            .padding(.vertical)
            .padding(.vertical)
            
            Spacer()
            
        }
        .padding(.vertical)
    }
    
}

#Preview {
    LoginView(
        viewModel: AuthenticationViewModel(
            authentication: globalAuthentication,
            client: globalClient
        )
    )
}
