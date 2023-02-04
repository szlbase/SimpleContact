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
    
    var selectedContact : ContactDB? {
        didSet{
            loadContact()
        }
    }
    
    var profileURL: URL?
    var firstName: String?
    var lastName: String?
    var identifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTopView.backgroundColor = UIColor(patternImage: UIImage(named: "green_gradient")!)
        innerSV.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        innerSV.isLayoutMarginsRelativeArrangement = true
        
        profilePictureIV.maskCircle(anyImage: UIImage(systemName: K.defaultProfileImage))
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.goToEditSegue {
            let destinationVC = segue.destination as! AddEditContactDetailsViewController
            destinationVC.selectedContact = selectedContact
            destinationVC.isEdit = true
        }
    }
    
    
    func loadContact() {
        if let urlString = selectedContact?.avartar, let url = URL(string: urlString) {
            profileURL = url
        }
        if let first_name = selectedContact?.first_name, let last_name = selectedContact?.last_name {
            firstName = first_name
            lastName = last_name
        }
        if let id = selectedContact?.id {
            identifier = String(id)
        }
    }
    
    func updateUI() {
        if let url = profileURL {
            profilePictureIV.load(url: url)
        }
        if let first_name = firstName, let last_name = lastName {
            nameLbl.text = first_name + " " + last_name
        }
        if let id = identifier {
            idLbl.text = id
        }
    }
}
