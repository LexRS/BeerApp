//
//  Item.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 08.07.2022.
//
//For caching images
import UIKit

enum Section {
    case main
}

class Item: Hashable {
    
    var image: UIImage!
    let url: URL!
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }

}
