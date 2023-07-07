//
//  Cache.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/6.
//

import Foundation
import UIKit

extension UIImage {
    static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            completion(image)
        } else {
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                if let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}
