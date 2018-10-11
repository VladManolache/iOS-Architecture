//
//  StatefulTableViewDataSource.swift
//  DataSourceProposal
//
//  Created by User on 14/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


class StatefulTableViewDataSource<T>: StatefulDataSource<T>, UITableViewDataSource {
    
    weak var delegate: DataSourceDelegate?
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must override in subclass")
    }
}
