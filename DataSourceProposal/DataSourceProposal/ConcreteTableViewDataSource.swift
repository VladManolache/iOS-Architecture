//
//  ConcreteTableViewDataSource.swift
//  DataSourceProposal
//
//  Created by Vlad Manolache on 13/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


class ConcreteTableViewDataSource: StatefulTableViewDataSource<AnyObject> {
            
    private static var cellIdentifier = "tableViewCellIdentifier"
    
    
    // MARK: - AnyDataSource
    
    override func executeLoadContent(_ successHandler: @escaping ([Item]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.items = [AnyObject]()
            for i in 0..<10 {
                let item = "Cell " + String(i)
                self.items.append(item as AnyObject)
            }
            
            DispatchQueue.main.async {
                successHandler(self.items)
            }
        })
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConcreteTableViewDataSource.cellIdentifier, for: indexPath) as UITableViewCell
        if let text = items[indexPath.row] as? String {
            cell.textLabel?.text = text
        }
        return cell
    }
    
}
