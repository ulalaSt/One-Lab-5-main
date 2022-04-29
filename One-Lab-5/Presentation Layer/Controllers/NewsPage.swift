//
//  ViewController.swift
//  One-Lab-5
//
//  Created by Farukh on 23.04.2022.
//

import UIKit
import SnapKit

class NewsPage: UIViewController {
    
    private let viewModel: NewsViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "Or choose from categories:"
        label.isHidden = true
        return label
    }()
    private let collectionView: UICollectionView = {
        let collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 20
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.isHidden = true
        return collectionView
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView)
        tableDirector.setTitle(with: "Top News")
        return tableDirector
    }()
    
    private lazy var collectionDirector: CollectionDirector = {
        let collectionDirector = CollectionDirector(collectionView: collectionView)
        return collectionDirector
    }()

    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .white
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        navigationItem.titleView = searchBar
        layout()
        bindViewModel()
        fetchData()
        setActionsForCells()
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        collectionDirector.updateItems(with: viewModel.getCategories().map({
            return CategoriesCellConfigurator(data: $0)
        }))
    }
    
    private func fetchData() {
        viewModel.getTopHeadLines()
    }
    
    private func bindViewModel() {
        viewModel.didLoadNews = { [weak self] news in
            self?.collectionView.isHidden = true
            self?.label.isHidden = true
            self?.tableDirector.updateItems(with: news.map({
                TopHeaderCellConfigurator(data: TopNewsHeader(author: $0.author,
                                                              title: $0.title,
                                                              urlToImage: $0.urlToImage,
                                                              description: $0.articleDescription,
                                                              date: $0.publishedAt,
                                                              content: $0.content,
                                                              selfHeight: 300))}
                                                          ))
        }
        viewModel.didLoadWithoutNewsTitleAndLabel = { [weak self] news in
            self?.collectionView.isHidden = true
            self?.label.isHidden = true
            self?.tableDirector.updateItems(with: news.map({
                TopHeaderCellConfigurator(data: TopNewsHeader(author: "",
                                                              title: $0.title,
                                                              urlToImage: $0.urlToImage,
                                                              description: "",
                                                              date: $0.publishedAt,
                                                              content: $0.content,
                                                              selfHeight: 150))}
                                                          ))
        }
    }
    
    private func setActionsForCells() {
        self.tableDirector.actionProxy.on(action: .didSelect) { (config: TopHeaderCellConfigurator, cell) in
            let data = config.data
            self.navigationController?.pushViewController(NewsDetailPage(newsData: TopNewsHeader(author: data.author,
                                                                                                 title: data.title,
                                                                                                 urlToImage: data.urlToImage,
                                                                                                 description: data.description,
                                                                                                 date: data.date,
                                                                                                 content: data.content,
                                                                                                 selfHeight: nil)), animated: true)
        }
        self.collectionDirector.actionProxy.on(action: .didSelect) { (config: CategoriesCellConfigurator, cell) in
            let data = config.data
            self.tableDirector.setTitle(with: "Top News in \(data)")
            self.viewModel.getTopHeadLinesForCategory(for: data)
            self.collectionView.isHidden = true
            self.label.isHidden = true
        }
    }
}

extension NewsPage: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchBar.endEditing(true)
            tableDirector.setTitle(with: "Search results")
            viewModel.searchHeadlines(query: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableDirector.setTitle(with: "Top News")
        viewModel.getTopHeadLines()
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionView.isHidden = false
        label.isHidden = false
    }
}
