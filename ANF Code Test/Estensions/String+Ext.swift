//
//  String+Ext.swift
//  ANF Code Test
//
//  Created by Cristian Perez on 1/24/25.
//
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }
    
    var sanitizedHTMLString: String {
        self.replacingOccurrences(of: "\\\"", with: "")
            .replacingOccurrences(of: "%22", with: "")
            .replacingOccurrences(of: "applewebdata://.*?/", with: "", options: .regularExpression)
    }
}
