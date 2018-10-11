//
//  ComposedDataSource.swift
//  DataSourceProposal
//
//  Created by User on 14/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation


class ComposedDataSource: NSObject {
    
    private var list = [StatefulDataSource<AnyObject>]()
    
    private var loadingState: StateMachine.State?

    weak var delegate: DataSourceDelegate?

    
    // MARK: - State
    
    func getCurrentState() -> StateMachine.State {
        if loadingState == nil {
            updateCurrentState()
        }
        return loadingState!
    }
    
    private func updateCurrentState() {
        var states = Array(repeating: 0, count: StateMachine.State.allValues.count)
        for dataSource in list {
            states[dataSource.getCurrentState().rawValue] += 1
        }
        
        for index in 0..<states.count {
            if states[index] > 0 {
                loadingState = StateMachine.State(rawValue: index)!
            }
        }
    }
    
    
    // MARK: - Manage data sources
    
    func addDataSource(dataSource: StatefulDataSource<AnyObject>) {
        dataSource.onItemsUpdated = { items in
            self.updateCurrentState()
            self.delegate?.didReloadData()
        }
        list.append(dataSource)
    }
    
    func removeDataSource(dataSource: StatefulDataSource<AnyObject>) {
        dataSource.onItemsUpdated = nil
        list = list.filter { $0 !== dataSource }
    }
    
    
    // MARK: - Manage Content
    
    func loadContent() {
        for dataSource in list {
            dataSource.loadContent()
        }
        updateCurrentState()
    }
    
    func clearContent() {
        for dataSource in list {
            dataSource.clearContent()
        }
        updateCurrentState()
    }
    
}
