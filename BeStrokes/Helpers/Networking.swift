//
//  Networking.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation

struct Networking {
    
    func fetchData(using url: String, completion: @escaping (Error?, Data?) -> Void) {
        guard let URL = URL(string: url) else {return}
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: URL) { (data, _, error) in
            guard let error = error else {
                guard let data = data else {return}
                completion(nil, data)
                return
            }
            completion(error, nil)
        }
        dataTask.resume()
    }
    
}
