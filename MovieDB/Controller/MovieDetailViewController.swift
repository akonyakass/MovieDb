//
//  MovieDetailViewController.swift
//  MovieDB
//


import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieId = 0
    let apiBaseURL = "https://api.themoviedb.org/3/movie"
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    let apiKey = "d351d913d674bd98da28dea154905f25"
    var movieData: MovieDetail?
    var castData: [CastElement] = []
    
    lazy var scrollMovieDetail: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    lazy var ratingStarStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    lazy var releaseDateAndGenresStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    lazy var ratingAndGenreStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var overviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var overviewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 18
        return stack
    }()
    
    lazy var imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    lazy var ratingInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    lazy var ratingLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    
    lazy var castCollectionView:UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.reuseIdentifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
        setupLayout()
        apiRequest()
    }
    
    func apiRequest() {
        NetworkManager.shared.loadMovieDetail(movieId: movieId) { result in
            self.movieData = result
            self.content()
            self.genreCollectionView.reloadData()
        
        }
        NetworkManager.shared.loadCast(movieId: movieId) { result in
            self.castData = result
            self.castCollectionView.reloadData()
            
        }
         
    }
    
    func content() {
        guard let safeData = movieData else { return }
        movieLabel.text = safeData.originalTitle
        releaseDateLabel.text = "Release Date: \(safeData.releaseDate?.prefix(4))"
        overviewTextLabel.text = safeData.overview
        
        URLSession.shared.dataTask(with: URL(string: "\(imageBaseURL)\(safeData.posterPath)")!) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.movieImage.image = image
                }
            }
        }.resume()
        setRatingStars(rating: safeData.voteAverage ?? 0)
        ratingLabel.text = String(format: "%.1f/10", safeData.voteAverage ?? 0)
        voteCountLabel.text = "\(String(describing: safeData.voteCount))K"
    }
    
    func setupLayout() {
        view.addSubview(scrollMovieDetail)

        overviewContainerView.addSubview(overviewTitleLabel)
        overviewContainerView.addSubview(overviewTextLabel)

        scrollMovieDetail.addSubview(mainStackView)

        imageStackView.addArrangedSubview(movieImage)
        imageStackView.addArrangedSubview(movieLabel)

        releaseDateAndGenresStackView.addArrangedSubview(releaseDateLabel)
        releaseDateAndGenresStackView.addArrangedSubview(genreCollectionView)

        ratingLabelStackView.addArrangedSubview(ratingLabel)
        ratingLabelStackView.addArrangedSubview(voteCountLabel)

        ratingInfoStackView.addArrangedSubview(ratingStarStackView)
        ratingInfoStackView.addArrangedSubview(ratingLabelStackView)

        ratingAndGenreStackView.addArrangedSubview(releaseDateAndGenresStackView)
        ratingAndGenreStackView.addArrangedSubview(ratingInfoStackView)

        mainStackView.addArrangedSubview(imageStackView)
        mainStackView.addArrangedSubview(ratingAndGenreStackView)
        mainStackView.addArrangedSubview(overviewContainerView)

        scrollMovieDetail.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollMovieDetail).offset(20)
            make.bottom.equalTo(scrollMovieDetail).offset(-20)
            make.leading.equalTo(scrollMovieDetail).offset(20)
            make.trailing.equalTo(scrollMovieDetail).offset(-20)
            make.width.equalTo(scrollMovieDetail).offset(-40)
        }

        movieImage.snp.makeConstraints { make in
            make.height.equalTo(424)
            make.width.equalTo(309)
        }

        movieLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStackView)
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(releaseDateAndGenresStackView)
        }

        genreCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(releaseDateAndGenresStackView)
        }

        ratingStarStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(releaseDateLabel)
        }

        overviewContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mainStackView)
        }

        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewContainerView).offset(10)
            make.leading.equalTo(overviewContainerView).offset(10)
            make.trailing.equalTo(overviewContainerView).offset(-10)
        }

        overviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(overviewContainerView).offset(10)
            make.trailing.equalTo(overviewContainerView).offset(-10)
            make.bottom.equalTo(overviewContainerView).offset(-10)
        }

        overviewContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(mainStackView).offset(-20)
        }

    }
    
    func setRatingStars(rating: Double) {

        let fullStarCount = Int(rating / 2)
        
        let hasHalfStar = (rating.truncatingRemainder(dividingBy: 2)) >= 1.0
        
        for _ in 0..<fullStarCount {
            let starImageView = UIImageView(image: UIImage(named: "star_filled"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            ratingStarStackView.addArrangedSubview(starImageView)
        }
        
        if hasHalfStar {
            let halfStarImageView = UIImageView(image: UIImage(named: "star_half"))
            halfStarImageView.translatesAutoresizingMaskIntoConstraints = false
            halfStarImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            halfStarImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            ratingStarStackView.addArrangedSubview(halfStarImageView)
        }
        
        let emptyStars = 5 - fullStarCount - (hasHalfStar ? 1 : 0)
        for _ in 0..<emptyStars {
            let emptyStarImageView = UIImageView(image: UIImage(named: "star_empty"))
            emptyStarImageView.translatesAutoresizingMaskIntoConstraints = false
            emptyStarImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            emptyStarImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            ratingStarStackView.addArrangedSubview(emptyStarImageView)
        }
    }

        
        private func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            return layout
        }

}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return movieData?.genres.count ?? 0
        }
        else {
            return castData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.reuseIdentifier, for: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if let genre = movieData?.genres[indexPath.item] {
                cell.genreLabel.text = genre.name
            }
            
            return cell
        }
        else {
           return UICollectionViewCell()
        }
        
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let genre = movieData?.genres[indexPath.item] {
            let label = UILabel()
            label.text = genre.name
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20, height: 30)
        }
        return CGSize(width: 50, height: 30)
    }
}
