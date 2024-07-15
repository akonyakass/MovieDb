//
//  ViewController.swift
//  testNoStoryBoard

import UIKit
import SnapKit
import  CoreData

class ViewController: UIViewController {
    
   private lazy var movieDBLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieDB"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
   private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
   private lazy var themeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThemeCell.self, forCellWithReuseIdentifier: ThemeCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
   private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    
   private var movieData: [Result] = []
   private var selectedCategoryIndex = 0
   private let categories = [
        ("Popular", "popular"),
        ("Top Rated", "top_rated"),
        ("Upcoming", "upcoming"),
        ("Now Playing", "now_playing")
    ]
    private var favoriteMovie:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        apiRequest(for: categories[selectedCategoryIndex].1)
        loadFavorite()
    }
    
   private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(movieDBLabel)
        view.addSubview(themeLabel)
        view.addSubview(themeCollectionView)
        view.addSubview(tableView)
        
        movieDBLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(movieDBLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        themeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(themeCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
   private func apiRequest(for category: String) {
        NetworkManager.shared.loadMovie(category: category) { results in
            self.movieData = results
            self.tableView.reloadData()
        }
    }
    
   private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 40)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    func saveFavorite(movie:Result) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistenConteiner.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context) else {return}
        let favoriteMovie = NSManagedObject(entity: entity, insertInto: context)
        favoriteMovie.setValue(movie.id, forKey: "movieId")
        favoriteMovie.setValue(movie.originalTitle, forKey: "title")
        favoriteMovie.setValue(movie.posterPath, forKey: "posterPath")
        do {
            try context.save()
        }
        catch {
            print("Error")
        }
    }
    func deleteFavorite(movie:Result) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistenConteiner.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let predicate = NSPredicate(format: "movieId == %@", "\(movie.id)")
        fetch.predicate = predicate
        do {
            let result = try context.fetch(fetch)
            for item in result {
                context.delete(item)
            }
            
        }
        catch {
            print("Error delete")
        }
        
    }
    func loadFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistenConteiner.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            favoriteMovie = try context.fetch(fetch)
            tableView.reloadData()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let result = movieData[indexPath.row]
        cell.conf(title: result.title, posterPath: result.posterPath)
        
        cell.isFavoriteMethod = { [weak self] _ in
            guard let self else {return}
            let isNotFavorite = !self.favoriteMovie.filter({($0.value(forKeyPath: "movieId") as? Int) == result.id}).isEmpty
            cell.tapIsFavorite(isFavorite: !isNotFavorite)
            if isNotFavorite {
                self.deleteFavorite(movie: result)
            }
            else {
                self.saveFavorite(movie: result)
               
            }
           loadFavorite()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = movieData[indexPath.row].id
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieId = movieId
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeCell.identifier, for: indexPath) as? ThemeCell else {
            fatalError("Unable to dequeue ThemeCell")
        }
        let category = categories[indexPath.row]
        cell.conf(with: category.0, isSelected: indexPath.row == selectedCategoryIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        themeCollectionView.reloadData()
        let selectedCategory = categories[selectedCategoryIndex].1
        apiRequest(for: selectedCategory)
    }
}
