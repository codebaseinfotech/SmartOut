//
//  ListDetailsTblViewCell.swift
//  SmartOut
//
//  Created by Ankit Gabani on 16/09/25.
//

import UIKit

class ListDetailsTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblwmu: UILabel!
    
    @IBOutlet weak var viewRifle: UIView!
    @IBOutlet weak var viewShortgun: UIView!
    @IBOutlet weak var viewMuzzleLoader: UIView!
    @IBOutlet weak var viewBow: UIView!
    
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblConditionS: UILabel!
    
    @IBOutlet weak var viewCondtionMain: UIView!
    @IBOutlet weak var viewMainSeason: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDrop: UIImageView!
    
    @IBOutlet weak var viewBottomLine: UIView!
    
    @IBOutlet weak var tblViewResults: UITableView!
    
    @IBOutlet weak var tblViewResultsHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewMooseMain: UIView!
    @IBOutlet weak var viewDear: UIView!
    
    @IBOutlet weak var lblMooseTitle: UILabel!
    
//    var isExpanded = false
//    var toggleAction: (() -> Void)?
    
    var arrListMoose: [MooseDraw] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblViewResults.backgroundColor = .clear
        tblViewResults.estimatedRowHeight = 44 // Set a default estimated height
        tblViewResults.rowHeight = UITableView.automaticDimension // Enable dynamic row height
        tblViewResults.register(UINib(nibName: "HunterDataTVCell", bundle: nil), forCellReuseIdentifier: "HunterDataTVCell")
        tblViewResults.dataSource = self
        tblViewResults.delegate = self
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTableViewHeight() {
        tblViewResults.layoutIfNeeded()
        tblViewResultsHeightConst.constant = tblViewResults.contentSize.height
    }
    
    func configure(with season: HuntingSeason) {
        lblwmu.text = season.short_wmu_list ?? ""
        
        viewRifle.isHidden = season.rifles_allowed != 1
        viewShortgun.isHidden = season.shotguns_allowed != 1
        viewMuzzleLoader.isHidden = season.muzzleloaders_allowed != 1
        viewBow.isHidden = season.bows_allowed != 1
        
        let seasonResident = (season.season_resident ?? "") + " (Resident)"
        let seasonNonResident = (season.season_non_resident ?? "") + " (Non-resident)"
        
        let seasonText = !seasonResident.trimmingCharacters(in: .whitespaces).isEmpty
        ? seasonResident + "\n" + seasonNonResident
        : seasonNonResident
        lblSeason.text = seasonText
        
        lblConditionS.text = season.conditions_text
        viewCondtionMain.isHidden = (season.conditions_text ?? "").isEmpty
        viewMainSeason.isHidden = (season.season_resident ?? "").isEmpty &&
        (season.season_non_resident ?? "").isEmpty
        
        
        tblViewResults.reloadData()
        updateTableViewHeight()
    }
    
}

extension ListDetailsTblViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListMoose.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewResults.dequeueReusableCell(withIdentifier: "HunterDataTVCell") as! HunterDataTVCell
        cell.backgroundColor = .clear
        
        let dicData = arrListMoose[indexPath.row]
        
        cell.lblTitle.font = .systemFont(ofSize: 12)
        cell.lblFValue.font = .systemFont(ofSize: 12)
        cell.lblSValue.font = .systemFont(ofSize: 12)
        cell.lblTValue.font = .systemFont(ofSize: 12)
        cell.lblFourValue.font = .systemFont(ofSize: 12)
        
        cell.lblTitle.textAlignment = .left
        
        DispatchQueue.main.async {
            cell.viewLine1.isHidden = false
            cell.viewLine2.isHidden = false
            cell.viewLine3.isHidden = false
            cell.viewLine4.isHidden = false
        }
        
//        DispatchQueue.main.async {
//            cell.viewFirst.addBorder(to: .right, color: .primary, thickness: 1)
//            cell.viewFirstData.addBorder(to: .right, color: .primary, thickness: 1)
//            cell.viewSecondData.addBorder(to: .right, color: .primary, thickness: 1)
//            cell.viewThirdData.addBorder(to: .right, color: .primary, thickness: 1)
//        }
        
        cell.widthSpring.constant = 70
        
        if dicData.id == 0 {
                        
            cell.lblTitle.text = "Draw"
            cell.lblFValue.text = "Primery Quota"
            cell.lblSValue.text = "Primary Min. Points Required"
            cell.lblTValue.text = "2nd Chance Quota"
            cell.lblFourValue.text = "2nd Chance Min. Points Required"
            
        } else {
            if let match = AppDelegate.appDelegate.dicAllData.moose_draw_types.first(where: { $0.id == dicData.draw_type_id }) {
                cell.lblTitle.text = match.name ?? ""
            } else {
                cell.lblTitle.text = "-"
            }
            
            cell.lblFValue.text = "\(dicData.primary_quota ?? 0)"
            cell.lblSValue.text = dicData.primary_min_points ?? ""
            cell.lblTValue.text = "\(dicData.second_chance_tags ?? 0)"
            cell.lblFourValue.text = dicData.second_min_points ?? ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
