//
//  NewsViewModel.swift
//  One-Lab-5
//
//  Created by Farukh on 23.04.2022.
//

import Foundation

class NewsViewModel {
    private let newsService: NewsService
    
    var didLoadNews: (([New]) -> Void)?
    var didLoadNewsWithoutTitle: (([New]) -> Void)?

    init(newsService: NewsService) {
        self.newsService = newsService
    }
    
    func getTopHeadLines() {
        newsService.getTopHeadLines {[weak self] result in
            switch result {
            case .success(let news):
                print(news)
                self?.didLoadNews?(news)
            case .failure(let error):
                print(error.localizedDescription.description)
            }
        }
    }
    func searchHeadlines(query: String) {
        newsService.searchForHeadlines(query: query) { [weak self] result in
            switch result {
            case .success(let news):
                self?.didLoadNewsWithoutTitle?(news)
            case .failure(let error):
                print(error.localizedDescription.description)
            }
        }
    }
    
    func getCategories() -> [String] { EndPoint.categories }
    
    func getTopHeadLinesForCategory(for category: String){
        newsService.getTopHeadLinesForCategory(category: category) { [weak self] result in
            switch result {
            case .success(let news):
                self?.didLoadNews?(news)
            case .failure(let error):
                print(error.localizedDescription.description)
            }
        }
    }
}
