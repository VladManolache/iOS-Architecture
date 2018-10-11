//
//  ViewModel.swift
//  ArchitectureProposal-V1
//
//  Created by User on 12/09/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import RxSwift


final class ViewModel: DatabaseServiceInjected {
    
    var didReceiveData: (([DemoEntity]) -> Void)?
    var failedToExecute: ((Error) -> Void)?

    private let disposeBag = DisposeBag()


    func startListeningForChanges() {
        databaseService.demoDataSource.observable.subscribe { [unowned self] values in
            
            if let values = values.element {
                self.didReceiveData?(values)
            }
            
        }.addDisposableTo(disposeBag)
    }
    
    func loadData() {
        let networkTask = DemoNetworkTask()
        networkTask.failure = { [unowned self] error in
            self.failedToExecute?(error)
        }
        networkTask.execute()
    }
}
