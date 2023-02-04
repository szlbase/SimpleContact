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
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var idTf: UILabel!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    var selectedContact : ContactDB? {
        didSet{
            loadContact()
        }
    }
    
    var isEdit = false
    var profileURL: URL?
    var firstName: String?
    var lastName: String?
    var identifier: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let networkMgr = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureView.backgroundColor = UIColor(patternImage: UIImage(named: "green_gradient")!)
        profilePictureIV.maskCircle(anyImage: UIImage(systemName: K.defaultProfileImage))
        
        updateUI()
    }
    
    @IBAction func doneBtnClicked(_ sender: UIBarButtonItem) {
        if let firstName = firstNameTF.text, let lastName = lastNameTF.text {
            if isEdit {
                if let id = selectedContact?.id {
                    updateContact(firstName: firstName, lastName: lastName, id: Int(id))
                }
            } else {
                let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if trimmedFirstName.count > 0 || trimmedLastName.count > 0 {
                    addNewContact(firstName: trimmedFirstName, lastName: trimmedLastName)
                } else {
                    displayWarning()
                }
            }
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
            firstNameTF.text = first_name
            lastNameTF.text = last_name
        }
        if isEdit {
            
            idView.isHidden = false
            if let id = identifier {
                idTf.text = id
            }
        } else {
            idView.isHidden = true
        }
    }
    
    func addNewContact(firstName: String, lastName: String) {
        
        networkMgr.createContact(firstName: firstName, lastName: lastName) { success, response in
            if success {

                if let response = response, let firstName = response[K.apiBodyFirstName] as? String, let lastName = response[K.apiBodyLastName] as? String, let id = response[K.apiBodyId] as? String {
                    
                    print("Create user : \(lastName) \(firstName) with \(id) successfully.")
                    
                    let newContact = ContactDB(context: self.context)
                    newContact.first_name = firstName
                    newContact.last_name = lastName
                    newContact.id = Int16(id)!
                    
                    self.saveItems()
                    
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                }

            } else {
                print("Failed")
            }
        }
    }
    
    func updateContact(firstName: String, lastName: String, id: Int) {
        networkMgr.updateContact(firstName: firstName, lastName: lastName, id: id) { success, response in
            if success {
                print("Updated successfully")
                self.selectedContact?.first_name = firstName
                self.selectedContact?.last_name = lastName
                
                self.saveItems()
                DispatchQueue.main.async {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func displayWarning() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please input either First Name or Last Name", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
