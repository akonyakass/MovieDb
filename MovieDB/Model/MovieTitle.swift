//
//  MovieTitle.swift
//  testNoStoryBoard


import Foundation
import UIKit

struct MovieTitle {
    var title: String
    var movieImage: UIImage?
    
    init(title: String, movieImage: UIImage?) {
        self.title = title
        self.movieImage = movieImage
    }
}
