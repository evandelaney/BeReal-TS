//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

final class ViewModelFactory {
    
    let client: APIClient
    let authentication: Authentication
    
    init(client: APIClient, authentication: Authentication)
    {
        self.authentication = authentication
        self.client = client
    }
    
    func makeAuthenticationViewModel() -> AuthenticationViewModel
    {
        AuthenticationViewModel(authentication: authentication, client: client)
    }
    
    func makeAuthenticatedUserViewModel(from viewModel: AuthenticationViewModel) -> AuthenticatedUserViewModel?
    {
        guard let user = viewModel.authenticatedUser else { return nil }
        
        return AuthenticatedUserViewModel(
            user: user,
            logOut: viewModel.logOut
        )
    }
    
    func makeFolderViewModel(from folder: Folder) -> ItemViewModel<Folder, [ any Item ]>
    {
        return ItemViewModel(
            root: folder,
            getter: client.getItems(at:),
            imageCreator: { (f, n, d) in
                _ = try await self.client.upload(data: d, filename: n, to: f)
                return try await self.client.getItems(at: f)
            },
            folderCreator: { (f, n) in
                _ = try await self.client.createFolder(in: f, named: n)
                return try await self.client.getItems(at: f)
            }
        )
    }
    
    func makeFileViewModel(from file: File) -> ItemViewModel<File, Data>
    {
        return ItemViewModel(
            root: file,
            getter: client.getData(for:),
            imageCreator: nil,
            folderCreator: nil
        )
    }
}

