//
//  SearchPresenter.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 29.04.2023.
//

import Foundation
import UIKit

protocol SearchViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol SearchPresenterProtocol {
    init(view: SearchViewProtocol, networkingService: NetworkServiceProtocol, router: RouterProtocol)
    func search(searchTerm: String)
    func getImage(forKey key: Int, completion: @escaping ((UIImage?) -> Void))
    var products: [drug]? {get set}
}


class SearchPresenter: SearchPresenterProtocol {
    var products: [drug]?
    weak var view: SearchViewProtocol?
    var networkingService: NetworkServiceProtocol?
    var router: RouterProtocol?
    
    required init(view: SearchViewProtocol, networkingService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkingService = networkingService
        self.router = router
    }
    
    // Makes request with searchTerm
    func search(searchTerm: String) {
        networkingService?.getSearchResults(searchTerm: searchTerm, completion: {[weak self] result in
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
    
    // Uploads pictures
    func getImage(forKey key: Int, completion: @escaping ((UIImage?) -> Void)) {
        if let image = networkingService?.cachedImagesForSearch?.object(forKey: key as AnyObject) {
            completion(image)
        } else {
            networkingService?.loadSearchImage(products: products!, index: key, completion: { image in
                completion(image)
            })
        }
    }
}
