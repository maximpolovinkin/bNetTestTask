//
//  DeseasesViewController.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import UIKit

class DeseasesViewController: UIViewController {
    var presenter: DiseasesPresenterProtocol?
    private var pageCounter = 1
    
    //MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
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
        view.backgroundColor = .white
        view.addSubview(mainTable)
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        setNavBar()
        setConstraints()
    }
    
    func setNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.4347847402, green: 0.7089360356, blue: 0.2936021686, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchButtonPressed))
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: nil)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = searchButton
        navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            mainTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            mainTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Actions
    @objc func searchButtonPressed() {
        presenter?.searchButtonTapped()
    }
}

//MARK: - TableView Delegate & DataSource
extension DeseasesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mainTable.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        presenter?.getImage(forKey: indexPath.row, completion: { image in
            DispatchQueue.main.async {
                cell.productImage.image = image
            }
        })
        
        if let name = presenter?.products?[indexPath.row].name, let description =  presenter?.products?[indexPath.row].description {
            cell.categoryName.text = name
            cell.categoryDescription.text = description
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 296)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = mainTable.cellForItem(at: indexPath) as! CustomCollectionViewCell
        presenter?.showDetail(index: indexPath.row, image: cell.productImage.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == ((presenter?.products?.count)! - 1) && pageCounter < 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
                self?.presenter?.getNewPage(offset: self?.pageCounter ?? 1)
            }
            self.pageCounter += 1
            print(pageCounter)
        }
    }
}

extension DeseasesViewController: DiseasesViewProtocol {
    func success() {
        mainTable.reloadData()
    }
    
    func failure(error: Error) {
        let alert = UIAlertController(title: "Упс! Возникла ошибка", message: "Перезагрузите приложение", preferredStyle: .alert)
        show(alert, sender: nil)
    }
}
