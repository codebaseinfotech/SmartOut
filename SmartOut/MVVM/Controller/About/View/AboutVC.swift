//
//  AboutVC.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    

}
