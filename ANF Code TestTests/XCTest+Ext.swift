//
//  XCTest+Ex.swift
//  ANF Code Test
//
//  Created by Cristian Perez on 1/24/25.
//
import XCTest
@testable import ANF_Code_Test

extension XCTestCase {
    func loadTestData() -> [ANFExploreData]? {
        guard let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let exploreData = try? JSONDecoder().decode([ANFExploreData].self, from: data) else {
            XCTFail("Failed to load test data from exploreData.json")
            return nil
        }
        return exploreData
    }
}
