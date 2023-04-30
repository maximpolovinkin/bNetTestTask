//
//  DetailDesiasePresenter.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import Foundation
import UIKit

protocol DetailDesiaseViewProtocol: AnyObject {
    func setContent(product: drug?, image: UIImage?, icon: UIImage?)
}

protocol DetailDesiasePresenterProtocol {
    init(view: DetailDesiaseViewProtocol, networkingService: NetworkServiceProtocol,  product: drug?, image: UIImage?, icon: UIImage?)
}


class DetailDesiasePresenter: DetailDesiasePresenterProtocol {
    weak var view: DetailDesiaseViewProtocol?
    var networkingService: NetworkServiceProtocol?
    var product: drug?
    var image: UIImage?
    var icon: UIImage?
    
    required init(view: DetailDesiaseViewProtocol, networkingService: NetworkServiceProtocol,  product: drug?, image: UIImage?, icon: UIImage?) {
        self.view = view
        self.networkingService = networkingService
        self.product = product
        self.image = image
        self.icon = icon
        
        self.view?.setContent(product: product, image: image, icon: icon)
        
    }
    
    private func getIconFor(product: drug?) {
        networkingService?.getIconFor(product: product, completion: {[weak self] image in
            self?.icon = image
        })
    }
}
