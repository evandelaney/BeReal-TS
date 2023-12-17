//
//  Created by Evan DeLaney on 12/17/23.
//

import Foundation

extension DateFormatter {
    
    static var unitTest: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")

        return formatter
    }()
}
