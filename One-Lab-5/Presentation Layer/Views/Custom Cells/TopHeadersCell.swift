//
//  TopHeadersCell.swift
//  One-Lab-5
//
//  Created by user on 24.04.2022.
//

import UIKit
import SnapKit

typealias TopHeaderCellConfigurator = TableCellConfigurator<TopHeadersCell, TopNewsHeader>

class TopHeadersCell: UITableViewCell {
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "gradient")
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    private let newsImageGradient: GradientView = {
        let newsImageGradient = GradientView(gradientColor: .black)
        newsImageGradient.clipsToBounds = true
        newsImageGradient.layer.cornerRadius = 20
        return newsImageGradient
    }()
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = .white
        authorLabel.numberOfLines = 0
        return authorLabel
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "NewYorkMedium-Bold", size: 20)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private var headerHeight: Double = 300
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        contentView.addSubview(newsImageGradient)
        newsImageGradient.snp.makeConstraints {
            $0.edges.equalTo(newsImageView)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
        }
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(titleLabel.snp.top)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}

extension TopHeadersCell: ConfigurableCell {
    
    typealias DataType = TopNewsHeader
    
    func configure(data: TopNewsHeader) {
        authorLabel.text = data.author
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        if let urlString = data.urlToImage {
            NewsServiceImpl.getMovieImage(urlString: urlString) {[weak self] result in
                switch result {
                case .success( let image):
                    print("success passed 000")
                    self?.newsImageView.image = image
                case .failure(_):
                    print("Error loading image from URL")
                }
            }
        }
        
        contentView.snp.updateConstraints({
            $0.width.equalToSuperview()
            $0.height.equalTo(data.selfHeight ?? 300)
        })
    }
}
