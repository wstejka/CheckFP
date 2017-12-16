//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

class FuelPricesPresenter: FuelPricesPresenterProtocol
{

    weak var view: FuelPricesViewProtocol?
    var interactor: FuelPricesInteractorInputProtocol?
    var wireFrame: FuelPricesWireFrameProtocol?
    
    var lowestPriceDescription: String! {
        return "highest".localized(withDefaultValue: "")
    }
    var highestPriceDescription: String! {
        return "lowest".localized(withDefaultValue: "")
    }
    var viewTitle: String! {
        return "AppHeading".localized(withDefaultValue: "")
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        // TODO: Invoke method on Wireframe
        // On this View there is nothing to show yet, at least at that moment
    }
    
    func viewDidLoad() {
        interactor?.initiate()
    }

    func viewWillAppear() {
        interactor?.startObserving()
    }
    
    func viewDidDisappear() {
        interactor?.stopObserving()
    }
    
    func configure(_ view: UIView, forItem: FuelTypeViewModel) {
        
        let fuelTypeView = view.addXib(forType: FuelTypeView.self)
        Utils.setupFuelType(type: forItem.fuelType.id.rawValue, inView: fuelTypeView)
    }
}

extension FuelPricesPresenter : FuelPricesInteractorOutputProtocol {
    
    func didReceiveItems(_ items: [FuelType]) {
        view?.reloadTable(with: items.map({ (fuelType) -> FuelTypeViewModel in
            
            let highestValue = UserConfigurationManager.compute(fromValue: fuelType.currentHighestPrice, fuelType: fuelType.id)
            let lowestValue = UserConfigurationManager.compute(fromValue: fuelType.currentLowestPrice, fuelType: fuelType.id)
            
            let highestValueText = highestValue.strRound(to: 2)
            let lowestValueText = lowestValue.strRound(to: 2)
            let fuelName = fuelType.name.localized()
            let perDateText = Double(fuelType.timestamp).timestampToString()
            
            let fuelTypeViewModel = FuelTypeViewModel(currentHighestPrice: highestValueText,
                                                      currentLowestPrice: lowestValueText,
                                                      fuelName: fuelName,
                                                      perDateLabel: perDateText,
                                                      fuelType : fuelType)
            return fuelTypeViewModel
        }))
    }
    
    
}


