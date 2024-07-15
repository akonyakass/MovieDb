//
//  ThemeCell.swift
//  MovieDB
//

import UIKit

class ThemeCell: UICollectionViewCell {
    static let identifier = "themeCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.layer.cornerRadius = 13
        label.layer.masksToBounds = true
        label.textColor = .black
        label.backgroundColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func conf(with text: String, isSelected: Bool) {
        titleLabel.text = text
        if isSelected {
            titleLabel.backgroundColor = .red
            titleLabel.textColor = .white
        } else {
            titleLabel.backgroundColor = .lightGray
            titleLabel.textColor = .black
        }
    }
}

