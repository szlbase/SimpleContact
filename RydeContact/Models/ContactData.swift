//
//  ContactData.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 3/2/23.
//

import Foundation

struct ContactsData: Decodable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [Contacts]
}

struct Contacts: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}
