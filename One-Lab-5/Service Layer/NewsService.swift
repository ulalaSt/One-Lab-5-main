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
    func getTopHeadLines(completion: @escaping (Result<[New],Error>) -> Void)
    func searchForHeadlines(query: String, completion: @escaping (Result<[New],Error>) -> Void)
    func getTopHeadLinesForCategory(category: String, completion: @escaping (Result<[New],Error>) -> Void)
}

class NewsServiceImpl: NewsService {
    
    
    //to get top headlines
    func getTopHeadLines(completion: @escaping (Result<[New],Error>) -> Void) {
        
        let urlString = String(format: "%@top-headlines", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        let parameters: Parameters = ["apiKey": EndPoint.apiKey, "country": EndPoint.country, "language": "en"]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                completion(.success(newsData.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //to get searched headlines
    func searchForHeadlines(query: String, completion: @escaping (Result<[New],Error>) -> Void) {
        
        let urlString = String(format: "%@everything", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        let queryParameters: Parameters = ["q": query, "apiKey": EndPoint.apiKey]
        
        AF.request(url, method: .get, parameters: queryParameters).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                completion(.success(newsData.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    //to get news for a specified category
    func getTopHeadLinesForCategory(category: String, completion: @escaping (Result<[New], Error>) -> Void) {
        
        let urlString = String(format: "%@top-headlines", EndPoint.baseUrl)
        guard let url = URL(string: urlString) else { return }
        let parameters: Parameters = ["apiKey": EndPoint.apiKey, "category": category, "language": "en"]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable { (response: DataResponse<NewsWrapper, AFError>) in
            switch response.result {
            case .success(let newsData):
                completion(.success(newsData.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    //to get image from string url
    static func getImageFrom(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
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




