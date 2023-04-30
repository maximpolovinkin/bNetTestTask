//
//  ModuleBuilder.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    func createDiseasesModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol, product: drug?, image: UIImage?) -> UIViewController
    func createSearchModule(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    //MARK: - Create Main Module
    func createDiseasesModule(router: RouterProtocol) -> UIViewController {
        let view = DeseasesViewController()
        let networkingServise = NetworkService()
        let presenter = DiseasesPresenter(view: view, networkServise: networkingServise, router: router)
        view.presenter = presenter
        
        return view
    }
    //MARK: - Create Detail Module
    func createDetailModule(router: RouterProtocol, product: drug?, image: UIImage?) -> UIViewController {
        let view = DetailDiseaseViewController()
        let networkingServise = NetworkService()
        networkingServise.getIconFor(product: product) {[weak view] icon in
            let presenter = DetailDesiasePresenter(view: view!, networkingService: networkingServise, product: product, image: image, icon: icon)
            view?.presenter = presenter
        }
        
        return view
    }
    //MARK: - Create Search Module
    func createSearchModule(router: RouterProtocol) -> UIViewController {
        let view = SearchViewController()
        let networkingServise = NetworkService()
        let presenter = SearchPresenter(view: view, networkingService: networkingServise, router: router)
        view.presenter = presenter
        
        return view
    }
}
