//
//  TagDataSource.swift
//  Photorama
//
//  Created by Rahul Ranjan on 4/20/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    var tags: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tag = tags[indexPath.row]
        let name = tag.value(forKey: "name")
        cell.textLabel?.text = name as? String
        
        return cell
    }
}
