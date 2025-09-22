//
//  ListDetailsTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
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
    
//    var isExpanded = false
//    var toggleAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
