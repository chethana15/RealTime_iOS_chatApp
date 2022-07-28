//
//  DatabaseManager.swift
//  RealTime_iOS_chatApp
//
//  Created by Cumulations Technologies Private Limited on 27/07/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    public var database = Database.database().reference()
    
//    public func test(){
//        database.child("Task").setValue("I'm learning Chatting app!!")
//    }
    
    
}

//MARK: - ACCOUNT MANAGEMENT
extension DatabaseManager {
    
    public func userExists(with email: String, completion:@escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { Snapshot in
            
            guard Snapshot.value != nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertUser(with userInfo: ChatAppUser){
        
        database.child(userInfo.safeEmail).setValue([
            "First_name": userInfo.firstName,
            "Last_name": userInfo.lastName,
            "Password": userInfo.password
            //we are not adding emailaddress because we are setting above values based on emailaddress as child values
            //it's also important to keep in mind that we are making sure that evry users must have unique email address
        ])
        
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let password: String
//    let profilePicUrl: String
    
    var safeEmail : String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: " ", with: "-")
        return safeEmail
    }
}
