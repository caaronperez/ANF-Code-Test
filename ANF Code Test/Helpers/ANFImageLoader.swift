//
//  ImageLoader.swift
//  ANF Code Test
//
//  Created by Cristian Perez on 1/24/25.
//


import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()

    init() {
        cache.totalCostLimit = 1024 * 1024 * 50 // An example of 50 MB of cache (this is just an example and it can be empty if not limit)
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }

            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
