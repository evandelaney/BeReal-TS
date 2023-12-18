//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct ItemErrorView: View {
    
    let error: Swift.Error
    
    var body: some View {
        VStack {
            Text("⚠️ Error:")
                .foregroundStyle(.red)
                .font(.largeTitle)
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    ItemErrorView(error:
                    NSError(domain: "Preview", code: 42)
    )
}
