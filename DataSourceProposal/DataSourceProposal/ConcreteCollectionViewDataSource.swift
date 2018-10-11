//
//  CollectionViewDataSource.swift
//  DataSourceProposal
//
//  Created by Vlad Manolache on 13/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


class ConcreteCollectionViewDataSource: StatefulCollectionViewDataSource<AnyObject> {
        
    private static var cellIdentifier = "collectionViewCellIdentifier"

    
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConcreteCollectionViewDataSource.cellIdentifier, for: indexPath) as UICollectionViewCell
        
        if let collectionViewCell = cell as? CollectionViewCell {
            
            if let text = items[indexPath.row] as? String {
                collectionViewCell.textLabel?.text = text
            }
        }
        return cell
    }
    
}

