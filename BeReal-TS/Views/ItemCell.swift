//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

protocol ItemCellDisplayable {
    
    var iconName: String { get }
    var localizedHeadline: String { get }
    func localizedSubheadline(with dateFormater: DateFormatter) -> String
}

struct ItemCell: View {
    
    let item: ItemCellDisplayable

    var body: some View {
        HStack {
            Image(systemName: item.iconName)
            VStack(alignment: .leading) {
                Text(item.localizedHeadline)
                    .font(.headline)
                Text(item.localizedSubheadline(with: .localizedShort))
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ItemCell(item: File.preview1)
}
