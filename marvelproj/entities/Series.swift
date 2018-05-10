//
//  Series.swift
//  marvelproj
//
//  Created by Andre Nogueira on 10/05/18.
//  Copyright © 2018 Andre Nogueira. All rights reserved.
//

import UIKit

struct Series {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Thumbnail?
}

extension Series{
    
    init?(json: [String: Any]) {
        
        if let id = json["id"] as? Int{
            self.id = id
        }
        if let title = json["title"] as? String{
            self.title = title
        }
        if let description = json["description"] as? String{
            self.description = description
        }
        if let thumbnail = json["thumbnail"] as? [String:Any]{
            self.thumbnail = Thumbnail(json: thumbnail)
        }
    }
}
