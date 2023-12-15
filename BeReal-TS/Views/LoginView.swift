//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct LoginView: View {
    
    var viewModel: AuthViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Spacer()
        
        Text("Welcome!")
            .font(.title)
        
        VStack(alignment: .leading) {
            Text("Username")
                .font(.caption)
            TextField("TheRealEvan555", text: $username)
                .textInputAutocapitalization(.never)
        }
        .padding()
        
        VStack(alignment: .leading) {
            Text("Password")
                .font(.caption)
            SecureField("password123", text: $password)
        }
        .padding()
        
        Spacer()
        
        Button("Log In") {
            Task {
                await viewModel.logIn(username: username, password: password)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(
        authentication: Authentication(),
        client: APIClient(hostname: "preview", urlSession: URLSession.shared)
    ))
}
