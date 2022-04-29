//
//  NewsWrapper.swift
//  One-Lab-5
//
//  Created by Farukh on 23.04.2022.
//

import Foundation

struct NewsWrapper: Codable {
    let status: String
    let totalResults: Int
    let articles: [New]
}

// MARK: - Article
struct New: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title, publishedAt
        case articleDescription = "description"
        case url, urlToImage, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

