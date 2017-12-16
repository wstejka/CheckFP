//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

class FuelPricesInteractor: FuelPricesInteractorInputProtocol
{
    var remoteDatamanager: FuelPricesRemoteDataManagerInputProtocol?
    weak var presenter: FuelPricesInteractorOutputProtocol?

    func initiate() {
        remoteDatamanager?.initiate()
    }
    
    func startObserving() {
        // to avoid retain cycle pass weak reference to self
        remoteDatamanager?.startObserving({ [weak self] (items) in
            self?.presenter?.didReceiveItems(items)
        })
    }
    func stopObserving() {
        remoteDatamanager?.stopObserving()
    }
}
