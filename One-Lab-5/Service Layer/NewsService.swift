//
//  NewsService.swift
//  One-Lab-5
//
//  Created by Farukh on 23.04.2022.
//

import Foundation
import Alamofire
import AlamofireImage

protocol NewsService {
    func getTopHeadLines(success: @escaping ([New]) -> Void, failure: @escaping (Error) -> Void)
    func getTopHeadLinesForCategory(category: String, completion: @escaping (Result<[New],Error>) -> Void)
    func searchForHeadlines(query: String, completion: @escaping (Result<[New],Error>) -> Void)
}

class NewsServiceImpl: NewsService {
    
    func getTopHeadLinesForCategory(category: String, completion: @escaping (Result<[New], Error>) -> Void) {
        let urlString = String(format: "%@top-headlines", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        
        let Params: Parameters = ["apiKey": EndPoint.apiKey, "category": category]
        
        AF.request(url, method: .get, parameters: Params).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                completion(.success(newsData.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopHeadLines(success: @escaping ([New]) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = String(format: "%@top-headlines", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        
        let queryParams: Parameters = ["apiKey": EndPoint.apiKey, "country": EndPoint.country, "language": "en"]
        
        AF.request(url, method: .get, parameters: queryParams).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                success(newsData.articles)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    // service Detail News
    func searchForHeadlines(query: String, completion: @escaping (Result<[New],Error>) -> Void) {
        let urlString = String(format: "%@everything", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        
        let queryParams: Parameters = ["q": query, "apiKey": EndPoint.apiKey]
        
        AF.request(url, method: .get, parameters: queryParams).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                completion(.success(newsData.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    static func getMovieImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: .get).responseImage { (response) in
            switch response.result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}




