//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct ItemsView: View {
    
    let items: [ Item ]
    
    var body: some View {
        List(items, id: \.identifier) { item in
            ItemCell(item: item)
        }
    }
}

#Preview {
    ItemsView(items: [File.preview1, File.preview2, Folder.preview1, Folder.preview2])
}
