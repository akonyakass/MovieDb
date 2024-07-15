//
//  MovieCell.swift
//  testNoStoryBoard
//

import UIKit

class MovieCell: UITableViewCell {
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    private lazy var favoriteImage:UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "star")
        return image
    }()
    
    var isFavoriteMethod: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func conf(title: String, posterPath: String) {
        movieTitle.text = title
        NetworkManager.shared.loadImage(posterPath: posterPath) { result in
            self.movieImage.image = result
        }
    }
    
    private func setupLayout() {
        let movieStackView = UIStackView(arrangedSubviews: [movieImage, movieTitle])
        movieStackView.axis = .vertical
        movieStackView.spacing = 12
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieStackView)
        
        NSLayoutConstraint.activate([
            movieImage.heightAnchor.constraint(equalToConstant: 424),
            movieImage.widthAnchor.constraint(equalTo: movieImage.heightAnchor, multiplier: 309.0 / 424.0),
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33)
        ])
        movieImage.addSubview(favoriteImage)
        favoriteImage.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.size.equalTo(60)
        }
        favoriteImage.isUserInteractionEnabled = true
        movieImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        favoriteImage.addGestureRecognizer(tap)
    }
    
    func tapIsFavorite(isFavorite:Bool) {
        favoriteImage.image =  isFavorite ? UIImage(systemName: "star.fill"): UIImage(systemName: "star")
    }
    @objc
    func tap() {
        isFavoriteMethod!(true)
    }
}
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
