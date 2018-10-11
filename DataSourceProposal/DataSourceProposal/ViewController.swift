//
//  ViewController.swift
//  DataSourceProposal
//
//  Created by Vlad Manolache on 13/12/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataSourceDelegate {
    

    // MARK: - Instance variables
    
    private let composedDataSource = ComposedDataSource()
    private let tableViewDataSource = ConcreteTableViewDataSource()
    private let collectionViewDataSource = ConcreteCollectionViewDataSource()
    
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    // MARK: - IBOutlet / IBAction
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        composedDataSource.clearContent()
        composedDataSource.loadContent()
        updateView()
    }
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        setupDataSources()
        
        composedDataSource.loadContent()
        updateView()
    }
    
    func setupDataSources() {
        tableView.dataSource = tableViewDataSource
        collectionView.dataSource = collectionViewDataSource
        
        composedDataSource.delegate = self
        composedDataSource.addDataSource(dataSource: tableViewDataSource)
        composedDataSource.addDataSource(dataSource: collectionViewDataSource)
    }

    
    // MARK: - Screen state
    
    func didReloadData() {
        tableView.reloadData()
        collectionView.reloadData()
        updateView()
    }
    
    func updateView() {
        let currentState = composedDataSource.getCurrentState()
        if currentState == .loadingContent || currentState == .refreshingContent {
            activityIndicator.startAnimating()
            tableView.isHidden = true
            collectionView.isHidden = true
        }
        else {
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            collectionView.isHidden = false
        }
    }
}

