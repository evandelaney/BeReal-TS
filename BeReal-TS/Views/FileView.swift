//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct FileView: View {
    
    @State var viewModel: ItemViewModel<File, Data>
    
    var body: some View {
        if let image = viewModel.image {
            VStack{
                Text(viewModel.root.name)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
            }
        }
        else if let error = viewModel.error {
            ItemErrorView(error: error)
                .padding()
        }
        else if viewModel.isLoading {
            ItemLoadingView()
                .padding()
        }
        else if viewModel.isEmpty {
            ItemEmptyView()
                .padding()
        }
    }
}

extension ItemViewModel where Detail == Data {
    
    var image: UIImage? {
        guard let data = items else { return nil }
        return UIImage(data: data)
    }
}
