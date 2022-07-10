//
//  BeerTableViewCell.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 07.07.2022.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    static let identifier = "BeerTableViewCell"
    
    var onReuse: () -> Void = {}
    
    private let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "portrait")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let beerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(beerImageView)
        contentView.addSubview(beerNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.size.height - 6
        
        beerImageView.frame = CGRect(x: 5 , y: 3, width: imageSize, height: imageSize)
        beerNameLabel.frame = CGRect(x: 10 + beerImageView.frame.size.width, y: 0, width: contentView.frame.size.width - 10 - beerImageView.frame.size.width, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beerImageView.image = nil
        beerNameLabel.text = nil
        onReuse()
    }
    
    func configure(with beerName: String, and image: UIImage) {
        beerNameLabel.text = beerName
        beerImageView.image = image
    }
}
