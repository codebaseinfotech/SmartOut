//
//  ExceptionsDetailsTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 17/09/25.
//

import UIKit

class ExceptionsDetailsTblViewCell: UITableViewCell {

    @IBOutlet weak var viewTopExceptionDetails: UIView!
    @IBOutlet weak var imgTOp: UIImageView!
    @IBOutlet weak var lblExceptionDetailsTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var viewBottomException: UIView!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblLimits: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    
    
    
    var isExpanded = false
    var onToggle: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBottomException.isHidden = true  // start collapsed
        imgDropDown.transform = .identity
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleExpansion))
        viewTopExceptionDetails.isUserInteractionEnabled = true
        viewTopExceptionDetails.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func toggleExpansion() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.viewBottomException.isHidden = !self.isExpanded
            self.imgDropDown.transform = self.isExpanded
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        }
        
        onToggle?()  // notify parent to refresh layout
    }
    
}
