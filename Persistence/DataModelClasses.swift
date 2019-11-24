//
//  DataModelClasses.swift
//  Purpose - Classes and structs that describe the shape of entities
//

import Foundation

struct FDCSearchBody: Codable {
    let generalSearchInput: String
    let requireAllWords: Bool = true
    let brandOwner: String?
    let includeDataTypes = FDCSearchIDT()
}
struct FDCSearchIDT: Codable {
    let Branded = true
}

struct FDCFood: Codable {
    let fdcId: Int
    let description: String?
    let brandOwner: String?
    let ingredients: String?
}

struct FDCSearchRespose: Codable {
    let foods: [FDCFood]
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
