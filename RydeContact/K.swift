//
//  K.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 4/2/23.
//

import Foundation

struct K {
    
    static let apiURL = "https://reqres.in/api/users"
    static let apiQueryPerPage = "per_page"
    static let apiBodyFirstName = "first_name"
    static let apiBodyLastName = "last_name"
    static let apiBodyId = "id"
    static let apiHeader = "application/json"
    
    struct methods {
        static let post = "POST"
        static let put = "PUT"
        static let get = "GET"
        static let delete = "DELETE"
    }
    
    static let goToContactDetailsSegue = "goToContactDetails"
    static let goToEditSegue = "goToEdit"
    
    static let contactCellItem = "ContactCell"
    
    static let defaultProfileImage = "person.circle.fill"
    
    static let hasLaunchKey = "hasLaunchBefore"
}
