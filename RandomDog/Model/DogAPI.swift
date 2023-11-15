//
//  DogAPI.swift
//  RandomDog
//
//  Created by Tracy Adams on 11/8/23.
//

import Foundation
import UIKit

class DogAPI {
    
    enum Endpoint{
        case randomDogImageCollection
        case randomImageForBreed(String)
        case breedsListAll
        
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomDogImageCollection: return "https://dog.ceo/api/breeds/image/random"
                //from associated property above 
            case .randomImageForBreed(let breed): return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .breedsListAll: return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        //create a URLSession
        let task1 = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
        task1.resume()
        
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (Dog?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        //start a task
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            //we have data
            //print(data)
            
            //Method 1: JSONSerialization
            //Tranlate to Dict, map out everything
            //            do {
            //                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            //                let url = json["message"] as! String
            //                print(url)
            //
            //            } catch {
            //                print(error)
            //            }
            
            //Method 2: Using Codable
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(Dog.self, from: data)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    //for All Dog Breeds: 
    class func requestBreedsList(completionHandler: @escaping([String], Error?) -> Void) {
        let breedsAllEndpoint = DogAPI.Endpoint.breedsListAll.url
        //start task
        let task = URLSession.shared.dataTask(with: breedsAllEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsList.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
    }
    
}
