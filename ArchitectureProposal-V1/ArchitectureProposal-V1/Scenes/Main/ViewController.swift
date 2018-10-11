//
//  ViewController.swift
//  ArchitectureProposal-V1
//
//  Created by Vlad Manolache on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit


final class ViewController: UIViewController {

    var viewModel: ViewModel = ViewModel()
    var router: MainRouter = MainRouter()
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBAction func didClickSubmit(_ sender: Any) {
        viewModel.loadData()
        
        router.route(to: .second)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.didReceiveData = { [unowned self] values in
            self.updateUI(values: values)
        }
        viewModel.failedToExecute = { [unowned self] error in
            self.showError(error)
        }
        viewModel.startListeningForChanges()
    }

    func updateUI(values: [DemoEntity]) {
        header.text = "Count: " + String(values.count)
    }
    
    func showError(_ error: Error) {
        // Show an error.
    }
}

