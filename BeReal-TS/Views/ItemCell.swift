//
//  Created by Evan DeLaney on 12/15/23.
//

import SwiftUI

struct ItemCell: View {
    
    let item: ItemCellDisplayable

    var body: some View {
        HStack {
            Image(systemName: item.iconName)
            VStack(alignment: .leading) {
                Text(item.localizedHeadline)
                    .font(.headline)
                Text(item.localizedSubheadline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

protocol ItemCellDisplayable {
    
    var iconName: String { get }
    var localizedHeadline: String { get }
    var localizedSubheadline: String { get }
}

extension File: ItemCellDisplayable {
    
    var iconName: String {
        "doc"
    }
    
    var localizedHeadline: String {
        name
    }
    
    var localizedSubheadline: String {
        dateFormatter.string(from: modified)
    }
}

extension Folder: ItemCellDisplayable {
    
    var iconName: String {
        "folder"
    }
    
    var localizedHeadline: String {
        name
    }
    
    var localizedSubheadline: String {
        dateFormatter.string(from: modified)
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ItemCell(item: File.preview1)
}
