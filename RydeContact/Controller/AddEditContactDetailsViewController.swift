//
//  AddEditContactDetailsViewController.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 2/2/23.
//

import Foundation
import UIKit

class AddEditContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var profilePictureIV: CustomImageView!
    @IBOutlet weak var firstNameTf: UILabel!
    @IBOutlet weak var lastNameTf: UILabel!
    @IBOutlet weak var idTf: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilePictureIV.maskCircle(anyImage: UIImage(named: "hugh"))
    }
}
