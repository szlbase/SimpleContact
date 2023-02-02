//
//  ContactDetailsViewController.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 2/2/23.
//

import Foundation
import UIKit

class ContactDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var customTopView: UIView!
    @IBOutlet weak var innerSV: UIStackView!
    @IBOutlet weak var profilePictureIV: CustomImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var customBottomView: UIView!
    @IBOutlet weak var idLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTopView.backgroundColor = UIColor(patternImage: UIImage(named: "green_gradient")!)
        innerSV.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        innerSV.isLayoutMarginsRelativeArrangement = true
        profilePictureIV.maskCircle(anyImage: UIImage(named: "hugh"))
    }
    
}
