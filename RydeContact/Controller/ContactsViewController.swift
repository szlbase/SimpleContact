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
    var contacts : [ContactDB] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        tableView.rowHeight = 80
        
        loadContacts()

//
//        NetworkManager.shared.createContact(firstName: "ShiZheng", lastName: "Lin") { success, response in
//            if success {
//                //Store inside database
//
//                if let response = response, let firstName = response["first_name"], let lastName = response["last_name"] {
//                    print("Create user : \(lastName) \(firstName) successfully.")
//                }
//
//            }
//        }
//
//        NetworkManager.shared.deleteContact(id: 1) { success in
//            if success {
//                //Delete from database
//                print("Delete successfully")
//            }
//        }
//
//        NetworkManager.shared.updateContact(firstName: "Shi Zheng", lastName: "Lin", id: 1) { success, response in
//            if success {
//                //Update inside database
//                print("Updated successfully")
//            }
//        }
        
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ContactCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        if let firstName = contacts[indexPath.row].first_name, let lastName = contacts[indexPath.row].last_name {
            cell.nameLbl.text = firstName + " " + lastName
        }
        
        
        return cell
        
    }

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension ContactsViewController {
    func loadContactIntoDatabase(completion: @escaping() -> ()) {
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
                            
                            self.saveContext()
                            
                        }
                        
                        UserDefaults.standard.set(true, forKey: "hasLaunchBefore")
                        completion()
                    }
                }
            }
        }
    }
    
    func loadContacts() {
            
        let hasLaunchBefore = UserDefaults.standard.bool(forKey: "hasLaunchBefore")
        
        if hasLaunchBefore {
            fetchFromDb()
        } else {
            loadContactIntoDatabase {
                self.fetchFromDb()
            }
        }
        
        tableView.reloadData()
    }
    
    func fetchFromDb() {
        let request : NSFetchRequest<ContactDB> = ContactDB.fetchRequest()
        
        do{
            contacts = try context.fetch(request)
            print(contacts.count)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
    }
}

