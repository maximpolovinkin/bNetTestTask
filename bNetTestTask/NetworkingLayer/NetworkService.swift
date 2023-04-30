//
//  NetworkService.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func getData(completion: @escaping (Result<[drug]?, Error>) -> Void)
    var cachedImages: NSCache<AnyObject, UIImage>? {get set}
    var cachedImagesForSearch: NSCache<AnyObject, UIImage>? {get set}
    func loadImage(products: [drug], index: Int, completion: @escaping ((UIImage?) -> Void))
    func loadSearchImage(products: [drug], index: Int, completion: @escaping ((UIImage?) -> Void))
    func getIconFor(product: drug?, completion: @escaping ((UIImage?) -> Void))
    func getNewPage(offset: Int, completion: @escaping (Result<[drug]?, Error>) -> Void)
    func getSearchResults(searchTerm: String, completion: @escaping (Result<[drug]?, Error>) -> Void)
    func clearSearchCache()
}

class NetworkService: NetworkServiceProtocol {
    
    var cachedImages: NSCache<AnyObject, UIImage>? = {
        let cachedImages = NSCache<AnyObject, UIImage>()
        
        return cachedImages
    }()

    var cachedImagesForSearch: NSCache<AnyObject, UIImage>? = {
        let cachedImages = NSCache<AnyObject, UIImage>()
        
        return cachedImages
    }()
    
    func getData(completion: @escaping (Result<[drug]?, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: "http://shans.d2.i-partner.ru/api/ppp/index/?limit=10") else { return }
            
            URLSession.shared.dataTask(with: url) {data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                do{
                    let data = try JSONDecoder().decode([drug].self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
     //MARK: - Images Loading
    func loadImage(products: [drug], index: Int, completion: @escaping ((UIImage?) -> Void)) {
        let str = "http://shans.d2.i-partner.ru/\(products[index].image!)".encodeUrl
        if let url = URL(string: str) {
            DispatchQueue.global().async {[weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self?.cachedImages?.setObject(image, forKey: index as AnyObject)
                        completion(image)
                    }
                }
            }
        }
    }
    
    func loadSearchImage(products: [drug], index: Int, completion: @escaping ((UIImage?) -> Void)) {
        let str = "http://shans.d2.i-partner.ru/\(products[index].image!)".encodeUrl
        if let url = URL(string: str) {
            DispatchQueue.global().async {[weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self?.cachedImagesForSearch?.setObject(image, forKey: index as AnyObject)
                        completion(image)
                    }
                }
            }
        }
    }
    
    func getIconFor(product: drug?, completion: @escaping ((UIImage?) -> Void)) {
        guard let str = product?.categories?.icon else { return }
        guard let url = URL(string: "http://shans.d2.i-partner.ru/\(str)".encodeUrl) else { return }
        print(url)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                       completion(img)
                    }
                }
            }
        }
    }
    
    func clearSearchCache() {
        self.cachedImagesForSearch?.removeAllObjects()
    }
    
     //MARK: - New Page Loading
    func getNewPage(offset: Int, completion: @escaping (Result<[drug]?, Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: "http://shans.d2.i-partner.ru/api/ppp/index/?limit=10&offset=\(offset*10)") else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                do{
                    let data = try JSONDecoder().decode([drug].self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
    //MARK: - Search request
    func getSearchResults(searchTerm: String, completion: @escaping (Result<[drug]?, Error>) -> Void) {
        clearSearchCache()
        createRequestWith(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            do{
                let data = try JSONDecoder().decode([drug].self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createRequestWith(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let params = createParametres(searchTerm: searchTerm)
        
        if let url = self.makeURLWith(params: params) {
            var request = URLRequest(url: url)
            request.httpMethod = "get"
            let task = createDataTaskFrom(request: request, completion: completion)
            task.resume()
        }
    }
    
    private func createParametres(searchTerm: String) -> [String : String] {
        var params = [String : String]()
        params["search"] = searchTerm
        params["limit"] = String(20)
        
        return params
    }
    
    private func makeURLWith(params: [String : String]) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "shans.d2.i-partner.ru"
        components.path = "/api/ppp/index/"
        components.queryItems = params.map {URLQueryItem(name: $0, value: $1)}
        
        return components.url
    }
    
    private func createDataTaskFrom(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask{
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

 //MARK: - Extension for make url
extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
