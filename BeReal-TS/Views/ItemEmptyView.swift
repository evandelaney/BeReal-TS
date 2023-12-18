//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct ItemEmptyView: View {
    
    var body: some View {
        VStack {
            Text("Nothing here.")
                .font(.title)
            Text("Why don't you add something?")
                .foregroundStyle(.secondary)
                .font(.headline)
        }
    }
}

#Preview {
    ItemEmptyView()
}
