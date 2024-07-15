//
//  FavoritesViewController.swift
//  MovieDB
//

import UIKit
import SnapKit
import CoreData

class FavoritesViewController: UIViewController {
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    lazy var movieTableView:UITableView = {
       let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return table
    }()
    var favorite:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadData()
    }

    func uploadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistenConteiner.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            favorite = try context.fetch(fetch)
            movieTableView.reloadData()
        }
        catch {
            
        }
        
    }
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(movieTableView)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(41)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(41)
            
        }
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
   

}
extension FavoritesViewController:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let favorite = favorite[indexPath.row]
        let posterPath = favorite.value(forKeyPath: "posterPath") as? String
        let title = favorite.value(forKeyPath: "title") as? String
        NetworkManager.shared.loadImage(posterPath: posterPath ?? "") { image in
            cell.conf(title: title ?? "", posterPath: posterPath ?? "")
        }
        return cell
    }
    
    
}
