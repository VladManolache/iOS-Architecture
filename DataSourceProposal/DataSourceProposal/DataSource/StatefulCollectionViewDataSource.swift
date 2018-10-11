//
//  StatefulCollectionViewDataSource.swift
//  DataSourceProposal
//
//  Created by User on 14/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


class StatefulCollectionViewDataSource<T>: StatefulDataSource<T>, UICollectionViewDataSource {
    
    weak var delegate: DataSourceDelegate?
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Must override in subclass")
    }
}
