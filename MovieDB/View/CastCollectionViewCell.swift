//
//  CastCollectionViewCell.swift
//  MovieDB
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    lazy var imageActor:UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = image.frame.size.width/2
        return image
    }()
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    lazy var roleNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()
    lazy var stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(imageActor)
        contentView.addSubview(stackView)
        stackView.addSubview(nameLabel)
        stackView.addSubview(roleNameLabel)
        imageActor.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(50)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(imageActor.snp.trailing).offset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
        
    }
    func conf(imagePath:String,nameActor:String,nameRole:String) {
        
    }
}
