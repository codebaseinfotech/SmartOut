//
//  ListTblVIewCell.swift
//  SmartOut
//
//  Created by iMac on 16/09/25.
//

import UIKit

class ListTblVIewCell: UITableViewCell {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottomDetails: UIView!
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var tblViewListDetails: UITableView!
    
    @IBOutlet weak var bottomDetailsHeightConstraint: NSLayoutConstraint!
    
    var arrHuntingSeasons: [HuntingSeason] = []

    var isExpanded: Bool = false {
        didSet {
            toggleView(animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblViewListDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblViewListDetails.isScrollEnabled = false
        
        tblViewListDetails.register(UINib(nibName: "ListDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ListDetailsTblViewCell")
        tblViewListDetails.dataSource = self
        tblViewListDetails.delegate = self
        
        viewBottomDetails.isHidden = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTopView))
//        viewTop.isUserInteractionEnabled = true
//        viewTop.addGestureRecognizer(tap)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            DispatchQueue.main.async { [self] in
                bottomDetailsHeightConstraint.constant = tblViewListDetails.contentSize.height
                if let tableView = self.superview as? UITableView {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            
        }
    }
    
    deinit {
        tblViewListDetails.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc private func didTapTopView() {
        isExpanded.toggle()
    }
    
    private func toggleView(animated: Bool) {
        let changes = {
            self.viewBottomDetails.isHidden = !self.isExpanded
            self.imgDropDown.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: changes)
        } else {
            changes()
        }
    }
    
}

extension ListTblVIewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHuntingSeasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewListDetails.dequeueReusableCell(withIdentifier: "ListDetailsTblViewCell") as! ListDetailsTblViewCell
        
        cell.lblwmu.text = arrHuntingSeasons[indexPath.row].short_wmu_list ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
