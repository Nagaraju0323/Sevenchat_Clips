//
//  MDLPslCategory.swift
//  Sevenchats
//
//  Created by APPLE on 05/01/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MDLPslCategory                              *
 * Description :                                         *
 *                                                       *
 ********************************************************/

import Foundation

public class MDLPslCategory :Encodable{
    
    public var  favourite_website_title: String!
    public var category_name : String!
    public var favourite_website_url : String!
    public var description : String!
    
    init(favourite_website_title:String,category_name:String,favourite_website_url:String,description:String) {
        self.favourite_website_title = favourite_website_title
        self.category_name = category_name
        self.favourite_website_url = favourite_website_url
        self.description = description
   
        
    }
}
