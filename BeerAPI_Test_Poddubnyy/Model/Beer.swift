

import Foundation

struct Beer: Codable {
    let name: String?
    let beerDescription: String?
    let imageURL: String?
    let ingredients: Ingredients?
    let foodPairing: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case beerDescription = "description"
        case imageURL = "image_url"
        case ingredients = "ingredients"
        case foodPairing = "food_pairing"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        beerDescription = try values.decodeIfPresent(String.self, forKey: .beerDescription)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        ingredients = try values.decodeIfPresent(Ingredients.self, forKey: .ingredients)
        foodPairing = try values.decodeIfPresent([String].self, forKey: .foodPairing)
    }
}

struct Ingredients: Codable {
    let malt: [Malt]?
    let hops: [Hop]?
    let yeast: String?
    
    enum CodingKeys: String, CodingKey {
        case malt = "malt"
        case hops = "hops"
        case yeast = "yeast"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        malt = try values.decodeIfPresent([Malt].self, forKey: .malt)
        hops = try values.decodeIfPresent([Hop].self, forKey: .hops)
        yeast = try values.decodeIfPresent(String.self, forKey: .yeast)
    }
}

struct Malt: Codable {
    let name: String?
    let amount: BoilVolume?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case amount = "amount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        amount = try values.decodeIfPresent(BoilVolume.self, forKey: .amount)
    }
}

struct Hop: Codable {
    let name: String?
    let amount: BoilVolume?
    let add: String?
    let attribute: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case amount = "amount"
        case add = "add"
        case attribute = "attribute"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        amount = try values.decodeIfPresent(BoilVolume.self, forKey: .amount)
        add = try values.decodeIfPresent(String.self, forKey: .add)
        attribute = try values.decodeIfPresent(String.self, forKey: .attribute)
    }
}

struct BoilVolume: Codable {
    let value: Double?
    let unit: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Double.self, forKey: .value)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
    }
}

typealias Beers = [Beer]

