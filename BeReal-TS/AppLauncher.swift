//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

// Keeps unit test coverage reports focused on the units under test.
// Source: https://mokacoding.com/blog/prevent-swiftui-app-loading-in-unit-tests/

@main
struct AppLauncher {
    
    static func main() throws
    {
        if NSClassFromString("XCTestCase") == nil {
            BeReal_TS.App.main()
        }
        else {
            TestApp.main()
        }
    }
}

private struct TestApp: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            Text("Running Unit Tests")
        }
    }
}
