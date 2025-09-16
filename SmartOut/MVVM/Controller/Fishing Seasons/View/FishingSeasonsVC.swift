//
//  FishingSeasonsVC.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit
import LGSideMenuController

class FishingSeasonsVC: UIViewController {

    @IBOutlet weak var lblListName: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var viewMainList: UIView!
    
    @IBOutlet weak var tblVIewList: UITableView!
    
    @IBOutlet weak var lblZoneWideSeason: UILabel!
    @IBOutlet weak var lblAdditionalOppo: UILabel!
    @IBOutlet weak var lblExceptions: UILabel!
    
    @IBOutlet weak var viewZoneWideBottomLine: UIView!
    @IBOutlet weak var viewAdditionalBottomLine: UIView!
    @IBOutlet weak var viewExceptionsBottomLine: UIView!
    
    @IBOutlet weak var tblViewZoneWide: UITableView!
    
    
    var arrList = ["FMZ 1", "FMZ 2", "FMZ 3", "FMZ 4", "FMZ 5", "FMZ 6", "FMZ 7", "FMZ 8", "FMZ 9", "FMZ 10"]
    
    var isDropDownVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblVIewList.register(UINib(nibName: "DropDownTblViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTblViewCell")
        tblVIewList.dataSource = self
        tblVIewList.delegate = self
        
        tblViewZoneWide.register(UINib(nibName: "ZoneWideTblViewCell", bundle: nil), forCellReuseIdentifier: "ZoneWideTblViewCell")
        tblViewZoneWide.dataSource = self
        tblViewZoneWide.delegate = self
        
        viewMainList.isHidden = true
        
        lblListName.text = arrList.first
        
        updateSegmentSelection(selected: .zoneWide)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func clickedSideMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedOpenList(_ sender: Any) {
        isDropDownVisible.toggle()
        
        UIView.animate(withDuration: 0.0) {
            self.viewMainList.isHidden = !self.isDropDownVisible
            
            self.imgDropDown.transform = self.isDropDownVisible ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    @IBAction func clickedzoneWideSeason(_ sender: Any) {
        updateSegmentSelection(selected: .zoneWide)
    }
    
    @IBAction func clickedAdditionalOppo(_ sender: Any) {
        updateSegmentSelection(selected: .additional)
    }
    
    @IBAction func clickedExceptions(_ sender: Any) {
        updateSegmentSelection(selected: .exceptions)
    }
    
    private enum SegmentType {
        case zoneWide, additional, exceptions
    }
    
    private func updateSegmentSelection(selected: SegmentType) {
        // Reset all labels to default (gray) and hide all bottom lines
        lblZoneWideSeason.textColor = .darkGray
        lblAdditionalOppo.textColor = .darkGray
        lblExceptions.textColor = .darkGray
        
        viewZoneWideBottomLine.backgroundColor = .clear
        viewAdditionalBottomLine.backgroundColor = .clear
        viewExceptionsBottomLine.backgroundColor = .clear
        
        // Apply active color (blue for example) and show bottom line
        switch selected {
        case .zoneWide:
            lblZoneWideSeason.textColor = .black
            viewZoneWideBottomLine.backgroundColor = .primary
        case .additional:
            lblAdditionalOppo.textColor = .black
            viewAdditionalBottomLine.backgroundColor = .primary
        case .exceptions:
            lblExceptions.textColor = .black
            viewExceptionsBottomLine.backgroundColor = .primary
        }
    }
    
}

extension FishingSeasonsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVIewList {
            return arrList.count
        } else if tableView == tblViewZoneWide {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblVIewList {
            let cell = self.tblVIewList.dequeueReusableCell(withIdentifier: "DropDownTblViewCell") as! DropDownTblViewCell
            
            cell.lblDropDownName.text = arrList[indexPath.row]
            
            return cell
        } else if tableView == tblViewZoneWide {
            let cell = self.tblViewZoneWide.dequeueReusableCell(withIdentifier: "ZoneWideTblViewCell") as! ZoneWideTblViewCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVIewList {
            return 60
        } else if tableView == tblViewZoneWide {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblListName.text = arrList[indexPath.row]
        
        isDropDownVisible = false
        UIView.animate(withDuration: 0.3) {
            self.viewMainList.isHidden = true
            self.imgDropDown.transform = .identity
        }
    }
    
}
