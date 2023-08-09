//
//  DataPersistenceManager.swift
//  NetflixApp
//
//  Created by Mohammed Saidam on 09/08/2023.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager{
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadingTitle(model :Title ,  completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.media_type = model.media_type
        item.id = Int64(model.id ?? 0)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_avarge = model.voute_average ?? 0.0
        item.vote_count = Int64(model.vote_count ?? 0)
        do{
           try  context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabasError.failedToSaveData))
            
        }
       
        
    }
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        let requst :NSFetchRequest<TitleItem>
        requst  = TitleItem.fetchRequest()
        do{
            
            let title = try context.fetch(requst)
            completion(.success(title))
        }catch{
            completion(.failure(DatabasError.failedToFetchData))
            
        }
        
    }
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
        
    }
    
}
