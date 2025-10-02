//
//  EmailPopup.swift
//  SmartOut
//
//  Created by Ankit Gabani on 15/09/25.
//

import UIKit

class EmailPopup: UIViewController {

    @IBOutlet weak var viewEmailMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewEmailMain.clipsToBounds = true
        viewEmailMain.layer.cornerRadius = 30
        viewEmailMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
    }

    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenEmail(_ sender: Any) {
        let email = "info@smartout.ca"
        let subject = "Smartout feedback"
        let body = "Hello, I have some feedback about the Smartout app..."
        
        // Encode subject & body to handle spaces
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Mail app not available
                let alert = UIAlertController(title: "Error",
                                              message: "Mail app is not available on this device.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
