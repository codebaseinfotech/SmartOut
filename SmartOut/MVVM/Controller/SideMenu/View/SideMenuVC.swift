//
//  SideMenuVC.swift
//  SmartOut
//
//  Created by iMac on 15/09/25.
//

import UIKit
import LGSideMenuController

class SideMenuVC: UIViewController {

    @IBOutlet weak var tblViewList: UITableView!
        
    @IBOutlet weak var viewMainAbout: UIView!
    @IBOutlet weak var imgAbout: UIImageView!
    @IBOutlet weak var lblAbout: UILabel!
    
    var arrImg = ["home_icon","bar_chart_icon", "moose", "aggregate_trout_and_salmon"]
    var arrList = ["Home","Hunter Reporting Data", "Ontario Hunting Seasons", "Ontario Fishing Seasons"]
    
    var selectedIndex: IndexPath?
    
    var isAboutSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblViewList.register(UINib(nibName: "SideMenuListTblViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuListTblViewCell")
        tblViewList.dataSource = self
        tblViewList.delegate = self
        
        selectedIndex = IndexPath(row: 0, section: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        if let selectedIndex = selectedIndex {
            tblViewList.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
            tblViewList.reloadData()
        }
    }

    @IBAction func clickedCloseMemnu(_ sender: Any) {
        self.sideMenuController?.hideLeftView(animated: true, completion: nil)
    }
    
    @IBAction func clickedAbout(_ sender: Any) {
        let AboutVC = AboutVC(nibName: "AboutVC", bundle: nil)
        let nav = UINavigationController(rootViewController: AboutVC)
        self.navigationController?.navigationBar.isHidden = true
        self.sideMenuController?.rootViewController = nav
        self.sideMenuController?.hideLeftView(animated: true, completion: nil)
        
        // Update selection state
        isAboutSelected = true
        selectedIndex = nil
        updateAboutSelectionUI()
        tblViewList.reloadData()
    }
    
    @IBAction func clickedEmail(_ sender: Any) {
        let emailPopupVC = EmailPopup(nibName: "EmailPopup", bundle: nil)
        let nav = UINavigationController(rootViewController: emailPopupVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .coverVertical
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func updateAboutSelectionUI() {
        if isAboutSelected {
            viewMainAbout.backgroundColor = UIColor.white
            lblAbout.textColor = UIColor.primary
            imgAbout.tintColor = UIColor.primary
            imgAbout.image = UIImage(named: "info_icon_orange")?.withRenderingMode(.alwaysTemplate)
        } else {
            viewMainAbout.backgroundColor = UIColor.clear
            lblAbout.textColor = UIColor.white
            imgAbout.tintColor = UIColor.white
            imgAbout.image = UIImage(named: "info_icon")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewList.dequeueReusableCell(withIdentifier: "SideMenuListTblViewCell") as! SideMenuListTblViewCell
        
        cell.lblName.text = arrList[indexPath.row]
        cell.imgMenuIcon.image = UIImage(named: arrImg[indexPath.row])
        
        if selectedIndex == indexPath {
            // Selected style
            cell.viewMain.backgroundColor = UIColor.white
            cell.lblName.textColor = UIColor.primary
            cell.imgMenuIcon.tintColor = UIColor.primary
            cell.imgMenuIcon.image = UIImage(named: arrImg[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        } else {
            // Default style
            cell.viewMain.backgroundColor = UIColor.clear
            cell.lblName.textColor = UIColor.white
            cell.imgMenuIcon.tintColor = UIColor.white
            cell.imgMenuIcon.image = UIImage(named: arrImg[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        isAboutSelected = false
        tblViewList.reloadData()
        updateAboutSelectionUI()
        
        if indexPath.row == 0 {
            let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
            let nav = UINavigationController(rootViewController: homeVC)
            self.navigationController?.navigationBar.isHidden = true
            self.sideMenuController?.rootViewController = nav
            self.sideMenuController?.hideLeftView(animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let HunterReportingDataVC = HunterReportingData(nibName: "HunterReportingData", bundle: nil)
            let nav = UINavigationController(rootViewController: HunterReportingDataVC)
            self.navigationController?.navigationBar.isHidden = true
            self.sideMenuController?.rootViewController = nav
            self.sideMenuController?.hideLeftView(animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let OntarioHuntingSeasonsVC = OntarioHuntingSeasonsVC(nibName: "OntarioHuntingSeasonsVC", bundle: nil)
            let nav = UINavigationController(rootViewController: OntarioHuntingSeasonsVC)
            self.navigationController?.navigationBar.isHidden = true
            self.sideMenuController?.rootViewController = nav
            self.sideMenuController?.hideLeftView(animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let FishingSeasonsVC = FishingSeasonsVC(nibName: "FishingSeasonsVC", bundle: nil)
            let nav = UINavigationController(rootViewController: FishingSeasonsVC)
            self.navigationController?.navigationBar.isHidden = true
            self.sideMenuController?.rootViewController = nav
            self.sideMenuController?.hideLeftView(animated: true, completion: nil)
        }
    }
    
}
