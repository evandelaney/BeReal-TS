//
//  Created by Evan DeLaney on 12/14/23.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    
    var authentication = Authentication()
    var client = APIClient(hostname: "163.172.147.216:8080", urlSession: URLSession.shared)
    
    var body: some Scene {
        WindowGroup {
            AuthContainerView(client: client, authentication: authentication)
        }
    }
}
