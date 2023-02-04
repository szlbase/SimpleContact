//
//  ViewController.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 2/2/23.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController {
    
    let networkMgr = NetworkManager.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contacts = [ContactDB]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.contactCellItem, bundle: nil), forCellReuseIdentifier: K.contactCellItem)
        tableView.rowHeight = 80

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        loadContacts()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ContactCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellItem, for: indexPath) as! ContactCell
        
        if let firstName = contacts[indexPath.row].first_name, let lastName = contacts[indexPath.row].last_name {
            cell.nameLbl.text = firstName + " " + lastName
        }
        
        if let urlString = contacts[indexPath.row].avartar, let url = URL(string: urlString) {
            cell.profilePictureIV.load(url: url)
        } else {
            cell.profilePictureIV.image = UIImage(systemName: K.defaultProfileImage)
        }
        
        return cell
        
    }

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToContactDetailsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.goToContactDetailsSegue {
            let destinationVC = segue.destination as! ContactDetailsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedContact = contacts[indexPath.row]
            }
        }
    }
    
}

//MARK: Database related methods
extension ContactsViewController {
    func loadContactIntoDatabase(completion: @escaping(_ success: Bool) -> ()) {
        networkMgr.fetchApiInfo { success in
            if success {
                self.networkMgr.fetchContacts(per_page: self.networkMgr.totalContacts) { success in
                    if success {
                        //Store inside database
                        for contact in self.networkMgr.contacts {
                            let newContact = ContactDB(context: self.context)
                            
                            newContact.id = Int16(contact.id)
                            newContact.first_name = contact.first_name
                            newContact.last_name = contact.last_name
                            newContact.avartar = contact.avatar
                            
                        }
                        self.saveContext()
                        UserDefaults.standard.set(true, forKey: K.hasLaunchKey)
                        completion(true)
                        return
                    } else {
                        completion(false)
                        return
                    }
                }
            }
        }
    }
    
    func loadContacts() {
            
        let hasLaunchBefore = UserDefaults.standard.bool(forKey: K.hasLaunchKey)
        
        if hasLaunchBefore {
            fetchFromDb()
        } else {
            loadContactIntoDatabase { success in
                if success {
                    self.fetchFromDb()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func fetchFromDb() {
        let request : NSFetchRequest<ContactDB> = ContactDB.fetchRequest()
        
        do{
            contacts = try context.fetch(request)
        } catch {
            print("Error loading contact \(error)")
        }
        
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving contact \(error)")
        }
        
    }
}

