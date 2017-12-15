//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

protocol FuelPricesViewProtocol: class
{
    var presenter: FuelPricesPresenterProtocol? { get set }
    // PRESENTER -> VIEW
    func reloadTable(with items: [FuelTypeViewModel])
    func insertFuelType(_ fuelType: FuelTypeViewModel, atRow: Int)
}

protocol FuelPricesWireFrameProtocol: class
{
    static func createFuelPriceView() -> UIViewController
    // PRESENTER -> WIREFRAME
}

protocol FuelPricesPresenterProtocol: class
{
    var view: FuelPricesViewProtocol? { get set }
    var interactor: FuelPricesInteractorInputProtocol? { get set }
    var wireFrame: FuelPricesWireFrameProtocol? { get set }
    
    var lowestPriceDescription : String! { get }
    var highestPriceDescription : String! { get }
    var viewTitle : String! { get }

    // VIEW -> PRESENTER
    func didSelectRowAt(_ indexPath: IndexPath)
    func viewDidLoad()
    func viewWillAppear()
}

protocol FuelPricesInteractorOutputProtocol: class
{
    // INTERACTOR -> PRESENTER
    func didReceiveItems(_ items: [FuelType])
}

protocol FuelPricesInteractorInputProtocol: class
{
    var presenter: FuelPricesInteractorOutputProtocol? { get set }
    var remoteDatamanager: FuelPricesRemoteDataManagerInputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func initiate()
    func startObserving()
}

protocol FuelPricesRemoteDataManagerInputProtocol: class
{
    // INTERACTOR -> DATAMANAGER
    func initiate()
    func startObserving(_ completion : @escaping FuelPricesCompletionHandler)

}


