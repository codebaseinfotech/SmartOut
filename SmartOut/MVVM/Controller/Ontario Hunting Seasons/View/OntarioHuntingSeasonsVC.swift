//
//  OntarioHuntingSeasonsVC.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class OntarioHuntingSeasonsVC: UIViewController {

    @IBOutlet weak var tblViewDropDown: UITableView!
    
    @IBOutlet weak var lblDropdownTitle: UILabel!
    @IBOutlet weak var imgDropdown: UIImageView!
    
    @IBOutlet weak var viewDropDownList: UIView!
    
    
    
    var arrDropDownList = ["All WMUs", "WMU 1A", "WMU 1B", "WMU 1C", "WMU 1D", "WMU 2", "WMU 3", "WMU 4", "WMU 5", "WMU 6"]
    
    var isDropDownVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewDropDown.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblViewDropDown.dataSource = self
        tblViewDropDown.delegate = self
        
        viewDropDownList.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenDropDown(_ sender: Any) {
        isDropDownVisible.toggle()  // Toggle state
        
        UIView.animate(withDuration: 0.3) {
            self.viewDropDownList.isHidden = !self.isDropDownVisible
            
            // Optional: Rotate dropdown arrow image
            self.imgDropdown.transform = self.isDropDownVisible ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    
    
}

extension OntarioHuntingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDropDownList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewDropDown.dequeueReusableCell(withIdentifier: "DropDownTblViewCell") as! DropDownTblViewCell
        
        cell.lblDropDownName.text = arrDropDownList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected name to label
        lblDropdownTitle.text = arrDropDownList[indexPath.row]
        
        // Hide dropdown after selection
        isDropDownVisible = false
        UIView.animate(withDuration: 0.3) {
            self.viewDropDownList.isHidden = true
            self.imgDropdown.transform = .identity
        }
    }
}
