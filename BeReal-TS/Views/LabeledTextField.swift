//
//  Created by Evan DeLaney on 12/17/23.
//

import SwiftUI

struct LabeledTextField: View {
    
    @Binding var text: String
    var isSecure: Bool = false
    let labelText: String
    let textFieldHint: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(labelText)
                .font(.caption)
            if isSecure {
                SecureField(textFieldHint, text: $text)
            }
            else {
                TextField(textFieldHint, text: $text)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
    }
}

#Preview {
    LabeledTextField(
        text: .constant(""),
        labelText: "Username",
        textFieldHint: "TheRealEvan555"
    )
}
