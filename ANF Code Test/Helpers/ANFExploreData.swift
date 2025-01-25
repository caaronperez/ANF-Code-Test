//
//  ANFExploreData.swift
//  ANF Code Test
//
//  Created by Cristian Perez on 1/24/25.
//

import Foundation

struct ANFExploreData: Codable {
    let title: String
    let backgroundImage: String
    let topDescription: String?
    let promoMessage: String?
    let bottomDescription: String?
    let content: [ContentItem]?
}

struct ContentItem: Codable {
    let target: String?
    let title: String?
}
