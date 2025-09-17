//
//  ExceptionsTblViewCell.swift
//  SmartOut
//
//  Created by iMac on 17/09/25.
//

import UIKit

class ExceptionsTblViewCell: UITableViewCell {

    @IBOutlet weak var viewTopExceptions: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var viewBottomExceptionsDetails: UIView!
    
    @IBOutlet weak var tblViewExceptionsDetails: UITableView!
    
    @IBOutlet weak var tblViewExceptionsDetailsConst: NSLayoutConstraint!
    
    
    var isExpanded: Bool = false
    var toggleAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblViewExceptionsDetails.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblViewExceptionsDetails.register(UINib(nibName: "ExceptionsDetailsTblViewCell", bundle: nil), forCellReuseIdentifier: "ExceptionsDetailsTblViewCell")
        tblViewExceptionsDetails.dataSource = self
        tblViewExceptionsDetails.delegate = self
        
        
        viewBottomExceptionsDetails.isHidden = true
        imgDropDown.transform = .identity
        
        // Tap gesture for expanding/collapsing
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleExpansion))
        viewTopExceptions.isUserInteractionEnabled = true
        viewTopExceptions.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        tblViewExceptionsDetails.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", object as? UITableView == tblViewExceptionsDetails {
            tblViewExceptionsDetailsConst.constant = tblViewExceptionsDetails.contentSize.height
            layoutIfNeeded()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc private func toggleExpansion() {
        self.isExpanded.toggle()

        self.viewBottomExceptionsDetails.isHidden = !self.isExpanded

        if self.isExpanded {
            self.tblViewExceptionsDetails.reloadData()
            
            // Force table layout update before reading contentSize
            self.tblViewExceptionsDetails.layoutIfNeeded()
            
            let newHeight = self.tblViewExceptionsDetails.contentSize.height
            self.tblViewExceptionsDetailsConst.constant = newHeight
        } else {
            self.tblViewExceptionsDetailsConst.constant = 0
        }

        UIView.animate(withDuration: 0.3) {
            self.imgDropDown.transform = self.isExpanded
                ? CGAffineTransform(rotationAngle: .pi)
                : .identity
            self.layoutIfNeeded()   // animate constraint change
        }
        
        toggleAction?()
    }
    
}

extension ExceptionsTblViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblViewExceptionsDetails.dequeueReusableCell(withIdentifier: "ExceptionsDetailsTblViewCell") as! ExceptionsDetailsTblViewCell
        
        cell.onToggle = { [weak self] in
            // Refresh height after expand/collapse
            self?.tblViewExceptionsDetails.beginUpdates()
            self?.tblViewExceptionsDetails.endUpdates()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
