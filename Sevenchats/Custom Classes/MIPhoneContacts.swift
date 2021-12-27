//
//  MIPhoneContacts.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class MIPhoneContacts: NSObject {
    
    typealias PhoneBookInfoBlock = (([CNContact?]) -> Void)
    var phoneBookInfoBlock:PhoneBookInfoBlock?
    
    private override init() {
        super.init()
    }
    
   private  static var contacts : MIPhoneContacts = {
        let contacts = MIPhoneContacts()
        return contacts
    }()
    
    static func shared() -> MIPhoneContacts {
        return contacts
    }
}

// MARK:- ------------ Contact related functions
extension MIPhoneContacts{
    
     func getContacts(contactInfoBlock:PhoneBookInfoBlock?) { //  ContactsFilter is Enum find it below
        phoneBookInfoBlock = contactInfoBlock
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers ==== ")
        }
        
//        var results: [CNContact] = []
        var results = [CNContact?]()
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers ==== ")

            }
        }
        
        if self.phoneBookInfoBlock != nil{
            self.phoneBookInfoBlock!(results)
            self.phoneBookInfoBlock = nil
        }
        
    }
}
