//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct ItemLoadingView: View {
    
    var body: some View {
        ProgressView {
            Text("Loading...")
        }
    }
}

#Preview {
    ItemLoadingView()
}
