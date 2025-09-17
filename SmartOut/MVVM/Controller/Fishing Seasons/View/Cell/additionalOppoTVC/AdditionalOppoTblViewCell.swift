//
//  AdditionalOppoTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 17/09/25.
//

import UIKit

class AdditionalOppoTblViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottomDetails: UIView!
    
    var toggleAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTop))
        viewTop.addGestureRecognizer(tap)
        viewTop.isUserInteractionEnabled = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(isExpanded: Bool) {
        viewBottomDetails.isHidden = !isExpanded
        imgDropDown.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
    }
    
    @objc private func didTapTop() {
        toggleAction?()
    }
    
}
