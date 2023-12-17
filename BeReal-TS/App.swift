//
//  Created by Evan DeLaney on 12/14/23.
//

import SwiftUI

struct App: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            AuthContainerView(factory: globalViewModelFactory)
        }
    }
}

let globalAuthentication = Authentication()

let globalClient = APIClient(
    hostname: "163.172.147.216:8080",
    urlSession: URLSession.shared
)

let globalViewModelFactory = ViewModelFactory(
    client: globalClient,
    authentication: globalAuthentication
)
