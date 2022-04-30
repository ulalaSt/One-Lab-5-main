

import UIKit
import SnapKit


//MARK: - to configure all views of the main view

class NewsMainPage: UIViewController {
    
    private let viewModel: NewsViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        return searchBar
    }()
    
    private let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.textColor = .lightGray
        categoryLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        categoryLabel.text = "Or choose from categories:"
        categoryLabel.isHidden = true
        return categoryLabel
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
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    //to give completion actions on events
    private func bindViewModel() {
        
        //for top case
        viewModel.didLoadNews = { [weak self] news in
            self?.collectionView.isHidden = true
            self?.categoryLabel.isHidden = true
            self?.tableDirector.updateItems(with: news.map(
                {
                    TopHeaderCellConfigurator(
                        data: TopNewsHeader(
                            author: $0.author,
                            title: $0.title,
                            urlToImage: $0.urlToImage,
                            description: $0.articleDescription,
                            date: $0.publishedAt,
                            content: $0.content,
                            selfHeight: 300))
                }
            ))
        }
        
        //for search case
        viewModel.didLoadNewsWithoutTitle = { [weak self] news in
            self?.collectionView.isHidden = true
            self?.categoryLabel.isHidden = true
            self?.tableDirector.updateItems(with: news.map(
                {
                    TopHeaderCellConfigurator(
                        data: TopNewsHeader(
                            author: "",
                            title: $0.title,
                            urlToImage: $0.urlToImage,
                            description: "",
                            date: $0.publishedAt,
                            content: $0.content,
                            selfHeight: 150))
                }
            ))
        }
    }
    
    //to get the beginning data from network
    private func fetchData() {
        viewModel.getTopHeadLines()
        collectionDirector.updateItems(with: viewModel.getCategories().map(){ CategoriesCellConfigurator(data: $0) })
    }
    
    //to set actions for cells
    private func setActionsForCells() {
        
        //to set didSelect for news tableView cell
        self.tableDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: TopHeaderCellConfigurator, cell) in
            let data = configurator.data
            self?.navigationController?.pushViewController(NewsDetailPage(
                newsData:TopNewsHeader(
                    author: data.author,
                    title: data.title,
                    urlToImage: data.urlToImage,
                    description: data.description,
                    date: data.date,
                    content: data.content,
                    selfHeight: nil)), animated: true)
        }
        
        //to set didSelect for category collection cell
        self.collectionDirector.actionProxy.on(action: .didSelect) { [weak self] (configurator: CategoriesCellConfigurator, cell) in
            let data = configurator.data
            self?.tableDirector.setTitle(with: "Top News in \(data)")
            self?.viewModel.getTopHeadLinesForCategory(for: data)
            self?.collectionView.isHidden = true
            self?.categoryLabel.isHidden = true
        }
    }
}




//MARK: -to add actions and to observe some events in the search bar

extension NewsMainPage: UISearchBarDelegate {
    
    //to search for headlines when is entered
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchBar.endEditing(true)
            tableDirector.setTitle(with: "Search results")
            viewModel.searchHeadlines(query: text)
        }
    }
    
    //to get topheadlines again when is canceled
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableDirector.setTitle(with: "Top News")
        viewModel.getTopHeadLines()
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    //to show collectionView when begins editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionView.isHidden = false
        categoryLabel.isHidden = false
    }
}
