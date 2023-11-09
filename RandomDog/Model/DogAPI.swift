//
//  DogAPI.swift
//  RandomDog
//
//  Created by Tracy Adams on 11/8/23.
//

import Foundation
import UIKit

class DogAPI {
    
    enum Endpoint: String {
        case randomDogImageCollection = "https://dog.ceo/api/breeds/image/random"
        var url: URL {
            return URL(string: self.rawValue)!
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
    
    class func requestRandomImage(completionHandler: @escaping (Dog?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomDogImageCollection.url
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
    
}
