//
//  APICaller.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 31/07/2023.
//

import Foundation

struct Constant{
    static let Api_Key = "06b3d4ef4aa8a1338644921d5566ac0c"
    
    static let base_Url = "https://api.themoviedb.org"
    static let Youtube_Api_Key = "AIzaSyDoijims0E9gb4HS2oAkdxSDuV3fG3Gt3c"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}
enum ApiError :Error {
    case failedTogetData
}


class ApiCaller{
    
    static let shared = ApiCaller()
    // This function that is Fetching Data
    
    func getTrendingMovies(completion: @escaping (Result <[Title],Error>) -> Void){
        // https://api.themoviedb.org/3/trending/all/day?api_key=06b3d4ef4aa8a1338644921d5566ac0c
        
        guard let url = URL(string: "\(Constant.base_Url)/3/trending/movie/day?api_key=\(Constant.Api_Key)")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data , _ , error in
            
            guard let data = data , error == nil else{return}
            
            do{
                let decoder = JSONDecoder()
                let results =   try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(ApiError.failedTogetData))
            }
            
            
        }
        
        task.resume()
    }
    func getTrendingTvs(completion: @escaping (Result <[Title],Error>) -> Void){
        
        guard let url = URL(string:"\(Constant.base_Url)/3/trending/tv/day?api_key=\(Constant.Api_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data,_,error in
            guard let data = data , error == nil else {return}
            do{
              
               let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(ApiError.failedTogetData))
                
            }
            
        }
        task.resume()
        
        
    }
    func upComingMovies(completion: @escaping (Result <[Title],Error>) -> Void){
        let url = URL(string:"\(Constant.base_Url)/3/movie/upcoming?api_key=\(Constant.Api_Key)" )
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url!)) { data, _, error in
            
            guard let data = data , error == nil else{return}
            
            do{
                
               let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(results.results))
            }catch{
                completion(.failure(ApiError.failedTogetData))
            }
            
        }
        task.resume()
    }
    func getPopular(completion: @escaping (Result <[Title],Error>) -> Void){
        let url  = URL(string:"\(Constant.base_Url)/3/movie/popular?api_key=\(Constant.Api_Key)&language=en-US&page=1" )
        let task = URLSession.shared.dataTask(with: URLRequest(url: url!)) { data, _, error in
            
            guard let data = data ,error == nil else{return}
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(ApiError.failedTogetData))
            }
            
        }
        task.resume()
        
    }
    func getTopRated(completion: @escaping (Result <[Title],Error>) -> Void){
        let url = URL(string: "\(Constant.base_Url)/3/movie/top_rated?api_key=\(Constant.Api_Key)&language=en-US&page=1")
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url!)) { data, _, error in
            
            guard let data = data , error == nil else{return}
            
            do{
                let decoder = JSONDecoder()
                let result = try   decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
                
            }catch{
                completion(.failure(ApiError.failedTogetData))
                
            }
            
            
            
        }
        task.resume()

        
    }
    func getDiscoverMovies(completion: @escaping (Result <[Title],Error>) -> Void){
        let url = URL(string: "\(Constant.base_Url)/3/discover/movie?api_key=\(Constant.Api_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url!)) { data, _ , error in
            
            guard let data = data , error == nil else {return}
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(ApiError.failedTogetData))
                
            }
            
            
        }
        task.resume()
    }
    
    func search(with query:String ,completion: @escaping (Result <[Title],Error>) -> Void ){
      guard  let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        guard let url = URL(string: "\(Constant.base_Url)/3/search/movie?api_key=\(Constant.Api_Key)&query=\(query)")else{return}
         let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, error in
             guard let data = data , error == nil else{return}
             do{
                 let decoder = JSONDecoder()
                 let result = try decoder.decode(TrendingTitleResponse.self, from: data)
                 completion(.success(result.results))
                 
             }catch{
                 completion(.failure(ApiError.failedTogetData))
                 
             }
            
        })
        task.resume()
    }
    func getMovie(with query:String ,completion: @escaping (Result <VideoElements,Error>) -> Void){
        // This code to replace String to %20 in Query
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{return}
        guard let url = URL(string: "\(Constant.YoutubeBaseURL)q=\(query)&key=\(Constant.Youtube_Api_Key)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            do{
                guard let data = data , error == nil else{return}
                let decoder =  JSONDecoder()
                let result = try decoder.decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(result.items[0]))
                
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
}
