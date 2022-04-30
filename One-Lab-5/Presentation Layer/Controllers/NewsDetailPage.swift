//
//  NewsDetailPage.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit
import SnapKit

class NewsDetailPage: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    private let titleView: UIView = {
        let titleView = UIView()
        titleView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = titleView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleView.addSubview(blurEffectView)
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 20
        return titleView
    }()
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "gradient")
        return imageView
    }()
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.numberOfLines = 0
        return authorLabel
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "NewYorkMedium-Bold", size: 20)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        return dateLabel
    }()
    private let contentTextLabel: UILabel = {
        let contentTextLabel = UILabel()
        contentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextLabel.numberOfLines = 0
        return contentTextLabel
    }()
    private let contentTextView: UIView = {
        let contentTextView = UIView()
        contentTextView.backgroundColor = .white
        contentTextView.layer.cornerRadius = 20
        contentTextView.clipsToBounds = true
        return contentTextView
    }()
    
    private let requestForMoreLabel: UILabel = {
        let requestForMoreLabel = UILabel()
        requestForMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        requestForMoreLabel.numberOfLines = 0
        requestForMoreLabel.text = ExtraText.text
        return requestForMoreLabel
    }()
    
    init(newsData: TopNewsHeader) {
        super.init(nibName: nil, bundle: nil)
        authorLabel.text = newsData.author
        titleLabel.text = newsData.title
        descriptionLabel.text = newsData.description
        dateLabel.text = newsData.date
        contentTextLabel.text = newsData.content
        if let urlString = newsData.urlToImage {
            NewsServiceImpl.getImageFrom(urlString: urlString) {[weak self] result in
                switch result {
                case .success( let image):
                    print("success")
                    self?.newsImageView.image = image
                case .failure(_):
                    print("Error loading image from URL")
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .tertiarySystemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        layoutSubviews()
    }
    func setupScrollView(){
        view.addSubview(newsImageView)
        newsImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalToSuperview().dividedBy(2)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func layoutSubviews() {
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.centerY).offset(-30)
            $0.leading.trailing.equalTo(view)
            $0.bottom.greaterThanOrEqualTo(view)
        }
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(contentTextLabel)
        contentView.addSubview(requestForMoreLabel)
        layoutTitleView()
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(titleView.snp.bottom).offset(20)
        }
        contentTextLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        requestForMoreLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        contentTextView.snp.makeConstraints {
            $0.bottom.greaterThanOrEqualTo(requestForMoreLabel)
        }
    }
    private func layoutTitleView() {
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(contentTextView.snp.top)
        }
        titleView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(20)
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
        }
        titleView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
