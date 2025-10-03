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
    
    
//    var isExpanded = false
//    var toggleAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblViewResults.register(UINib(nibName: "HunterDataTVCell", bundle: nil), forCellReuseIdentifier: "HunterDataTVCell")
        tblViewResults.dataSource = self
        tblViewResults.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    }
    
}

extension ListDetailsTblViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewResults.dequeueReusableCell(withIdentifier: "HunterDataTVCell") as! HunterDataTVCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}
