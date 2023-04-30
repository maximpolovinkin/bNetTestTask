//
//  CustomCollectionViewCell.swift
//  bNetTestTask
//
//  Created by Максим Половинкин on 28.04.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(productImage)
        self.addSubview(categoryName)
        self.addSubview(categoryDescription)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
    //MARK: - UI Elements
    var productImage: UIImageView = {
        let image = UIImageView()
        image.frame = .zero
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.backgroundColor = .yellow
        image.layer.cornerRadius = 8
        
        return image
    }()
    
    var categoryName: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Болезни однолетних зерновых бобовых культур"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.29
        label.attributedText = NSMutableAttributedString(string: "БОЛЕЗНИ ЛУКА И ЧЕСНОКА", attributes: [NSAttributedString.Key.kern: 0.26, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        return label
    }()
    
    var categoryDescription: UILabel = {
        let text = UILabel()
        text.frame = .zero
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = .systemFont(ofSize: 12, weight: .medium)
        text.textColor = UIColor(red: 0.683, green: 0.691, blue: 0.712, alpha: 1)
        text.text = "Среди болезней зерновых культур в настоящее время наиболь­шую опасность представляют ..."
        text.isUserInteractionEnabled = false
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.19
        text.attributedText = NSMutableAttributedString(string: "Среди болезней зерновых культур в настоящее время наиболь­шую опасность представляют ...", attributes: [NSAttributedString.Key.kern: 0.12, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        
        return text
    }()
    
    //MARK: - UI Settings
    func setViews() {
        self.backgroundColor = .white
        self.addSubview(productImage)
        self.addSubview(categoryName)
        self.addSubview(categoryDescription)
        
        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor(red: 0.282, green: 0.298, blue: 0.298, alpha: 0.15).cgColor
        self.layer.isGeometryFlipped = false
        
        setConstraints()
        categoryName.sizeToFit()
        categoryDescription.sizeToFit()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            productImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            productImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            productImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -202),
            
            categoryName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            categoryName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            categoryName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 12),
            categoryName.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            categoryDescription.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            categoryDescription.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            categoryDescription.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 6),
            categoryDescription.heightAnchor.constraint(lessThanOrEqualToConstant: 152)
        ])
    }
}
