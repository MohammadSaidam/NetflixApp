//
//  Movie.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 31/07/2023.
//

import Foundation

struct TrendingTitleResponse :Decodable{
    // Cannot find type 'Movie' in scope
    let results :[Title]
    
}
// this code was error that error is The data couldn’t be read because it is missing" error when decoding JSON in Swift
// the solve the problem
// all attributes in struct must be optional
struct Title :Decodable{
    let id :Int?
    let media_type :String?
    let original_name :String?
    let original_title :String?
    let overview :String?
    
    let poster_path :String?
    let release_date :String?
    let title :String?
    let vote_count :Int?
   
    let voute_average :Double?
}
