//
//  DiseasesPresenter.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import Foundation
import UIKit

protocol DiseasesViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol DiseasesPresenterProtocol {
    init(view: DiseasesViewProtocol, networkServise: NetworkServiceProtocol, router: RouterProtocol)
    func showDetail(index: Int, image: UIImage?)
    func getProducts()
    func getImage(forKey key: Int, completion: @escaping ((UIImage?) -> Void))
    func getNewPage(offset: Int)
    func searchButtonTapped()
    var products: [drug]? {get set}
}


class DiseasesPresenter: DiseasesPresenterProtocol {
    var products: [drug]?
    weak var view: DiseasesViewProtocol?
    var networkServise: NetworkServiceProtocol?
    var router: RouterProtocol?
    
    required init(view: DiseasesViewProtocol, networkServise: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkServise = networkServise
        self.router = router
        
        getProducts()
    }
    
    func showDetail(index: Int, image: UIImage?) {
        router?.showDetailController(product: self.products![index], image: image)
    }
    
    func searchButtonTapped() {
        router?.showSearchController()
    }
    
    func getProducts() {
        networkServise?.getData(completion: {[weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.products = products
                    self?.view?.success()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.failure(error: error)
                }
            }
        })
    }
    
    func getImage(forKey key: Int, completion: @escaping ((UIImage?) -> Void)){
        if let image = networkServise?.cachedImages?.object(forKey: key as AnyObject) {
            completion(image)
        } else {
            networkServise?.loadImage(products: products!, index: key, completion: { image in
                completion(image)
            })
        }
    }
    
    func getNewPage(offset: Int) {
        networkServise?.getNewPage(offset: offset, completion: {[weak self] result in
            switch result {
            case .success(let newProd):
                if let newProd = newProd {
                    self?.products! += newProd
                }
                self?.view?.success()
            case .failure(let error):
                self?.view?.failure(error: error)
            }
        })
    }
}
