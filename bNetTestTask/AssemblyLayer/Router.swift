//
//  Router.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import Foundation
import UIKit

protocol MainRouter {
    var navBar: UINavigationController? {get set}
    var moduleBuilder: ModuleBuilderProtocol? {get set}
}

protocol RouterProtocol: MainRouter {
    func initialVC()
    func showDetailController(product: drug?, image: UIImage?)
    func showSearchController()
}

class Router: RouterProtocol {
    var navBar: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    required init(navBar: UINavigationController?, moduleBuilder: ModuleBuilderProtocol?) {
        self.navBar = navBar
        self.moduleBuilder = moduleBuilder
    }
    
    func initialVC() {
        guard let DeseasesVC = moduleBuilder?.createDiseasesModule(router: self) else { return }
        
        navBar?.viewControllers = [DeseasesVC]
        navBar?.navigationBar.topItem?.title = "Препараты"
    }
    
    func showDetailController(product: drug?, image: UIImage?) {
        guard let detailVC = moduleBuilder?.createDetailModule(router: self, product: product, image:
                                                                image) else { return }
        navBar?.pushViewController(detailVC, animated: true)
    }
    
    func showSearchController() {
        guard let searchVC = moduleBuilder?.createSearchModule(router: self) else { return }
        navBar?.pushViewController(searchVC, animated: true)
    }
}
