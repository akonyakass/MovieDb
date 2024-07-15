//
//  NetworkManager.swift
//  MovieDB
//
//  Created by astanahub on 25.05.2024.
//

import Foundation
import UIKit
import Alamofire


class NetworkManager {
    static var shared = NetworkManager()
    
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    private let apiKey = "d351d913d674bd98da28dea154905f25"
    private lazy var urlComponent:URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return component
    }()
  
    func loadMovieDetail(movieId:Int, completion: @escaping (MovieDetail) -> Void)
    {
        urlComponent.path = "/3/movie/\(movieId)"
        let url = urlComponent.url!
        AF.request(url).responseDecodable(of: MovieDetail.self) { response in
            let data = response.result
            if let result = try? data.get() {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    func loadCast(movieId:Int, completion: @escaping ([CastElement]) -> Void) {
        urlComponent.path = "/3/movie/\(movieId)/casts"
        let url = urlComponent.url!
        AF.request(url).responseDecodable(of: Cast.self) { response in
            if let result = try? response.result.get() {
                DispatchQueue.main.async {
                    completion(result.cast)
                }
            }
            
        }
    }
    func loadMovie(category:String, completion: @escaping ([Result]) -> Void) {
        urlComponent.path = "/3/movie/"+category
        let url = urlComponent.url!
        
        AF.request(url).responseDecodable(of: Movie.self) { response in
            let data = response.result
            if let result = try? data.get() {
                DispatchQueue.main.async {
                    completion(result.results)
                }
                
            }
        }
    }
        
       

    func loadImage(posterPath:String, complation: @escaping (UIImage) -> Void)  {
        let urlString = imageBaseURL + posterPath
        guard let url  = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complation(image)
                }
            }
        }.resume()
        
        
        
    }
    
    
}
