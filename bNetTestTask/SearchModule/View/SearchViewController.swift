//
//  SearchViewController.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 29.04.2023.
//

import UIKit

class SearchViewController: UIViewController {
    var presenter: SearchPresenter?
    private var timer = Timer()
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.searchController!.isActive = true
    }
    
    //MARK: - UI Elements
    let mainTable: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    //MARK: - UI Settings
    func setViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(mainTable)
        mainTable.delegate = self
        mainTable.dataSource = self
        
        createSearchBar()
        setConstraints()
    }
    
    func createSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        navigationItem.searchController = search
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Найти продукт"
        self.navigationController?.navigationItem.titleView = search.searchBar
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            mainTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            mainTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func success() {
        mainTable.reloadData()
    }
    
    func failure(error: Error) {
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0001, execute: { [weak self] in
            self!.navigationItem.searchController!.searchBar.becomeFirstResponder()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] _ in
            if searchText.count >= 2 {
                self?.presenter?.search(searchTerm: searchText)
            }
        })
    }
}

//MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainTable.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        if let name = presenter?.products![indexPath.row].name {
            cell.categoryName.text = name
        }
        
        if let description = presenter?.products![indexPath.row].description {
            cell.categoryDescription.text = description
        }
        
        presenter?.getImage(forKey: indexPath.row, completion: { image in
            DispatchQueue.main.async {
                cell.productImage.image = image
            }
        })
        
        mainTable.reloadItems(at: [indexPath])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 296)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 15)
    }
}
