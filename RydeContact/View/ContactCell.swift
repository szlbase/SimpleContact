//
//  ContactCell.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 2/2/23.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var profilePictureIV: CustomImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureIV.layer.borderWidth = 1.0
        profilePictureIV.layer.masksToBounds = false
        profilePictureIV.layer.borderColor = UIColor.white.cgColor
        profilePictureIV.layer.cornerRadius = self.frame.size.width/2
        profilePictureIV.clipsToBounds = true
        profilePictureIV.maskCircle(anyImage: UIImage(systemName: K.defaultProfileImage))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
