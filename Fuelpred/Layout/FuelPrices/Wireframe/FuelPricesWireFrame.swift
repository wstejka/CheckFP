//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

class FuelPricesWireFrame: FuelPricesWireFrameProtocol
{
    static func createFuelPriceView() -> UIViewController {

        let view = FuelPricesWireFrame.fromStoryboard()
        let presenter: FuelPricesPresenterProtocol & FuelPricesInteractorOutputProtocol = FuelPricesPresenter()
        let interactor: FuelPricesInteractorInputProtocol = FuelPricesInteractor()
        let remoteDataManager: FuelPricesRemoteDataManagerInputProtocol = FuelPricesRemoteDataManager()
        let wireFrame: FuelPricesWireFrameProtocol = FuelPricesWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDataManager
        
        return view
    }
    
    static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "FuelPrices", bundle: nil)) -> FuelPricesView {
        let controller = storyboard.instantiateViewController(withIdentifier: "FuelPricesView") as! FuelPricesView
        return controller
    }

    // TODO: It seems like a good place to turn it into func which conforms to new ViewDissmisableProtocol. I'll think about it later ...
    // Needed only if View instantiated object modaly
    static func dismiss(from view: FuelPricesViewProtocol, completion: (() -> Void)?) {
        if let view = view as? UIViewController {
            view.dismiss(animated: true, completion: completion)
        }
    }
}


