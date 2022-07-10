//
//  DetailViewController.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 09.07.2022.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var name: String = ""
    var beerDescription: String = ""
    var imageUrlString: String = ""
    var ingredients: Ingredients?
    var foodPairing = [String]()
    var ratio: Double = 0.0
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .none
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .none
        return label
    }()
    
    private let ingrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Noteworthy", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private let foodPairingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Noteworthy", size: 17)
        label.numberOfLines = 0
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        displayScrollView()
        displayContentView()
        displayImageView()
        displayNameLabel()
        displayDescLabel()
        displayIngrLabel()
        displayFoodPairingLabel()
        if let imageURL = URL(string: imageUrlString) {
            let _ = ImageLoader.shared.loadImage(imageURL) { result in
              do {
                let image = try result.get()
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
              } catch {
                print(error)
              }
            }
        } else {
            imageView.image = nil
        }
    }
    
    private func displayScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().offset(0)
        }
    }
    
    private func displayContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(0)
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(scrollView.snp.bottom).offset(0)
        }
    }
    
    private func displayImageView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(40)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.3)
            make.height.lessThanOrEqualTo(300)
        }
    }
    
    private func displayNameLabel() {
        nameLabel.text = name
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-20)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    private func displayDescLabel() {
        descLabel.text = beerDescription
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
    }

    private func displayIngrLabel() {
        ingrLabel.text = "Ingredients: \n"
        if let ingredients = ingredients, let malts = ingredients.malt {
            for malt in malts {
                ingrLabel.text! += "\(malt.name!) \(malt.amount!.value!) \(malt.amount!.unit!)\n"
            }
        }
        ingrLabel.text?.removeLast()
        
        contentView.addSubview(ingrLabel)
        ingrLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
    }
    
    private func displayFoodPairingLabel() {
        foodPairingLabel.text = "Food pairing: \n"
        for pair in foodPairing {
            foodPairingLabel.text! += "\(pair) \n"
        }
        contentView.addSubview(foodPairingLabel)
        foodPairingLabel.snp.makeConstraints { make in
            make.top.equalTo(ingrLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
