//
//  NetworkManager.swift
//  RydeContact
//
//  Created by LIN SHI ZHENG on 3/2/23.
//

import Foundation

class NetworkManager: ObservableObject {
    
    let urlString = "https://reqres.in/api/users"
    
    var contacts = [Contacts]()
    var totalContacts = 0
    
    static let shared = NetworkManager()
    
    func fetchApiInfo(completion: @escaping(_ success:Bool) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completion(false)
                    return
                }
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let result = try decoder.decode(ContactsData.self, from: data)
                        self.totalContacts = result.total
                        completion(true)
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchContacts(per_page: Int = 10, completion: @escaping (_ success: Bool) -> Void) {
        if let url = URL(string: urlString)?.appending(queryItems: [
            URLQueryItem(name: "per_page", value: String(per_page))
        ]) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let result = try decoder.decode(ContactsData.self, from: data)
                        self.contacts.append(contentsOf: result.data)
                        completion(true)
                    } catch {
                        print(error)
                        completion(false)
                    }
                }
            }
            task.resume()
        }
    }
    
    func createContact(firstName: String, lastName: String, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> Void) {
        let body: [String: AnyHashable] = [
            "first_name": firstName,
            "last_name": lastName
        ]
        let url = "https://reqres.in/api/users"
        request(method: "POST", body: body, url: url, header: "application/json") { data, response  in
            
            guard let data = data else { return }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                completion(true, response)
            } catch {
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func updateContact(firstName: String, lastName: String, id: Int, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> Void) {
        let body: [String: String] = [
            "first_name": firstName,
            "last_name": lastName
        ]
        let url = "https://reqres.in/api/users/\(id)"
        
        request(method: "PUT", body: body, url: url, header: "application/json") { data, response  in
            
            guard let data = data else { return }
            
            if let responseHeader = response as? HTTPURLResponse {
                if responseHeader.statusCode == 200 {
                    do {
                        let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        completion(true, response)
                    } catch {
                        print(error)
                        completion(false, nil)
                    }
                } else {
                    print("Update failed.")
                }
            }
            
            
        }
    }
    
    func deleteContact(id: Int, completion: @escaping(_ success: Bool) -> Void) {
        let url = "https://reqres.in/api/users/\(id)"
        request(method: "DELETE", body: nil, url: url, header: nil) { _, response in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func request(method: String, body: [String: AnyHashable]?, url: String, header: String?, completion: @escaping (Data?, URLResponse?) -> Void) {
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            if let header = header {
                request.setValue(header, forHTTPHeaderField: "Content-Type")
            }
            
            if let body = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            }
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(nil, nil)
                    return
                }
                completion(data,response)
            }
            task.resume()
        }
    }
}
