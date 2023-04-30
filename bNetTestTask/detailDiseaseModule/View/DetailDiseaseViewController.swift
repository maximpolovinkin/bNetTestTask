//
//  DetailDiseaseViewController.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import UIKit

class DetailDiseaseViewController: UIViewController {
    var presenter: DetailDesiasePresenter?
    
    //MARK:  - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    //MARK: - UI Elements
    var icon: UIImageView = {
        let img = UIImageView()
        img.frame = .zero
        img.backgroundColor = .red
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 16
        
        return img
    }()
    
    var productImage: UIImageView = {
        let img = UIImageView()
        img.frame = .zero
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    var likeButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btn.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = #colorLiteral(red: 0.4347847402, green: 0.7089360356, blue: 0.2936021686, alpha: 1)
        
        return btn
    }()
    
    var productName: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    var productDescription: UITextView = {
        let tf = UITextView()
        tf.frame = .zero
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 15, weight: .regular)
        tf.textColor =  UIColor(red: 0.683, green: 0.691, blue: 0.712, alpha: 1)
        tf.sizeToFit()
        tf.isScrollEnabled = false
        
        return tf
    }()
    
    let byButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" ГДЕ КУПИТЬ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(named: "pin"), for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.937, green: 0.937, blue: 0.941, alpha: 1).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    //MARK: - UI Settings
    func setViews(){
        view.backgroundColor = .white
        
        view.addSubview(icon)
        view.addSubview(productImage)
        view.addSubview(likeButton)
        view.addSubview(productName)
        view.addSubview(productDescription)
        view.addSubview(byButton)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            icon.widthAnchor.constraint(equalToConstant: 32),
            icon.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            icon.heightAnchor.constraint(equalToConstant: 32),
            
            productImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 127),
            productImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -131),
            productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            productImage.heightAnchor.constraint(equalToConstant: 183),
            
            likeButton.widthAnchor.constraint(equalToConstant: 32),
            likeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 124),
            likeButton.heightAnchor.constraint(equalToConstant: 32),
            
            productName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14),
            productName.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            productName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 32),
            productName.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
            
            productDescription.leftAnchor.constraint(equalTo: productName.leftAnchor),
            productDescription.widthAnchor.constraint(equalToConstant: 328),
            productDescription.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 8),
            productDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            byButton.leftAnchor.constraint(equalTo: productName.leftAnchor),
            byButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            byButton.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 16),
            byButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
        ])
    }
}

//MARK: -  DetailDesiaseViewProtocol
extension DetailDiseaseViewController: DetailDesiaseViewProtocol {
    func setContent(product: drug?, image: UIImage?, icon: UIImage?) {
        DispatchQueue.main.async {
            guard let image = image, let product = product, let icon = icon else { return }
            
            self.productImage.image = image
            self.icon.image = icon
            
            if let name = product.name {
                self.productName.text = name
            }
            if let description = product.description {
                self.productDescription.text = description
                self.productDescription.sizeToFit()
            }
        }
    }
}
