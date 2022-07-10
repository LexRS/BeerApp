//
//  ImageLoader.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 08.07.2022.
//

import Foundation
import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
      if let image = loadedImages[url] {
        completion(.success(image))
        return nil
      }

      let uuid = UUID()

      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        defer {self.runningRequests.removeValue(forKey: uuid) }

        if let data = data, let image = UIImage(data: data) {
          self.loadedImages[url] = image
          completion(.success(image))
          return
        }
          
        guard let error = error else {
          // without an image or an error, we'll just ignore this for now
          // you could add your own special error cases for this scenario
          return
        }

        guard (error as NSError).code == NSURLErrorCancelled else {
          completion(.failure(error))
          return
        }

        // the request was cancelled, no need to call the callback
      }
      task.resume()
        
      runningRequests[uuid] = task
      return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
    
}
