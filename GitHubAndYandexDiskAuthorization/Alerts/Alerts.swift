

import Foundation
import UIKit


final class AlertsError {
    
    static func alertError(title : String,message : String ) -> UIAlertController {
        let dialogMessage = UIAlertController(title: "Network Error", message: "Connect to the network", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        return dialogMessage
    }
}
