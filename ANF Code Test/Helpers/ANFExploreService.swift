//
//  ExploreService.swift
//  ANF Code Test
//
//  Created by Cristian Perez on 1/24/25.
//

import Foundation

protocol ANFExploreServiceProtocol {
    func fetchExploreData(completion: @escaping ([ANFExploreData]?) -> Void)
}

class ANFExploreService: ANFExploreServiceProtocol {
    static let shared = ANFExploreService()

    func fetchExploreData(completion: @escaping ([ANFExploreData]?) -> Void) {
        guard let url = URL(string: "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let exploreData = try JSONDecoder().decode([ANFExploreData].self, from: data)
                completion(exploreData)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

class MockANFExploreService: ANFExploreServiceProtocol {
    func fetchExploreData(completion: @escaping ([ANFExploreData]?) -> Void) {
        let mockData = [
            ANFExploreData(
                title: "Mock Title 1",
                backgroundImage: "mockImage1.jpg",
                topDescription: "Mock Top Description 1",
                promoMessage: "Mock Promo 1",
                bottomDescription: "Mock Bottom Description 1",
                content: [
                    ContentItem(target: "https://example.com/1", title: "Shop Now")
                ]
            ),
            ANFExploreData(
                title: "Mock Title 2",
                backgroundImage: "mockImage2.jpg",
                topDescription: "Mock Top Description 2",
                promoMessage: "Mock Promo 2",
                bottomDescription: nil,
                content: []
            )
        ]
        completion(mockData)
    }
}
