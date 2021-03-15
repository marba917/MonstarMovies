//
//  DBManager.swift
//  MonstarMovies
//
//  Created by Mario Jaramillo on 3/15/21.
//


import UIKit
import CoreData
import CoreLocation

public class DBManager {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    
    //MARK: - Guests methods

    static func getFavoriteMovies() -> [Movie] {
        
        var moviesArray: [Movie] = []
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                var movie = Movie()
                movie.id = data.value(forKey: "id") as! Int
                movie.title = data.value(forKey: "title") as! String
                movie.vote_average = data.value(forKey: "vote_average") as! Double
                movie.image = data.value(forKey: "image") as! String
                movie.release_date = data.value(forKey: "release_date") as! Date
                moviesArray.append(movie)
            }
                        
            return moviesArray
            
        } catch {
            
            print("Failed retreiving movies")
            return []
        }
    }
    
    static func addMovie(movie: Movie) {
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)
    
        newMovie.setValue(movie.id, forKey: "id")
        newMovie.setValue(movie.title, forKey: "title")
        newMovie.setValue(movie.vote_average, forKey: "vote_average")
        newMovie.setValue(movie.image, forKey: "image")
        newMovie.setValue(movie.release_date, forKey: "release_date")
    
        do {
            try context.save()
        } catch {
            print("Failed saving new movie")
        }
    }
    
    static func deleteMovie(movieId: Int) {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %i", movieId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for object in result {
                context.delete(object as! NSManagedObject)
            }
            
        } catch {
            
            print("Failed deleting movie")
        }
    }
    
}
