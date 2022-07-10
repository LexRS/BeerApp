//
//  ViewController.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 06.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var beers = Beers()
    
    private var pullControl = UIRefreshControl()
    
    var page: Int = 1 //var for pagination
    
    private let beerTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        beerTableView.dataSource = self
        beerTableView.delegate = self
        view.addSubview(beerTableView)
        
        pullControl.attributedTitle = NSAttributedString(string: "Reload data")
                pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
                if #available(iOS 10.0, *) {
                    self.beerTableView.refreshControl = pullControl
                } else {
                    self.beerTableView.addSubview(pullControl)
                }
        
        APIManager.shared.getBeerList(pagination: false, page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let beers):
                    self.updateUI(with: beers)
                case .failure(let error):
                    let ErrorAlert = UIAlertController(title: "Error", message: "Problem with internet connection or server, please try again later", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    ErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(ErrorAlert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        beerTableView.frame = view.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffY = scrollView.contentOffset.y
        if contentOffY > abs(beerTableView.frame.size.height - scrollView.contentSize.height - 80) {
            guard !APIManager.shared.isPaginating else {
                return // we already fetched more data
            }

            self.beerTableView.tableFooterView = createSpinner()
            page += 1
            
            print(self.page)
            APIManager.shared.getBeerList(pagination: true, page: page) { result in
                DispatchQueue.main.async {
                    self.beerTableView.tableFooterView = nil
                    
                    switch result {
                    case .success(let beers):
                        self.updateUI(with: beers)
                    case .failure(let error):
                        let ErrorAlert = UIAlertController(title: "Error", message: "Problem with internet connection or server, please try again later", preferredStyle: UIAlertController.Style.alert)

                        // add an action (button)
                        ErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                        // show the alert
                        self.present(ErrorAlert, animated: true, completion: nil)
                        print(error.localizedDescription)
                    }
                }
            }
            print("fetch more")
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        page = 1
        beers.removeAll()
        self.beerTableView.reloadData()
        APIManager.shared.getBeerList(pagination: false, page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let beers):
                    self.updateUI(with: beers)
                case .failure(let error):
                    let ErrorAlert = UIAlertController(title: "Error", message: "Problem with internet connection or server, please try again later", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    ErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(ErrorAlert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }
        }
        self.pullControl.endRefreshing()
        
    }
    
    private func updateUI(with beers: Beers) {
        self.beers.append(contentsOf: beers)
        self.beerTableView.reloadData()
    }
    
    func createSpinner() -> UIView {
        let spinner = UIActivityIndicatorView()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.beerTableView.frame.width, height: 80))
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        
        return footerView
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.identifier, for: indexPath) as! BeerTableViewCell
        cell.accessoryType = .disclosureIndicator
        
        if let imageURL = URL(string: beers[indexPath.row].imageURL!) {
            let token = ImageLoader.shared.loadImage(imageURL) { result in
              do {
                let image = try result.get()
                DispatchQueue.main.async {
                    cell.configure(with: self.beers[indexPath.row].name!, and: image)
                }
              } catch {
                print(error)
              }
            }

            cell.onReuse = {
              if let token = token {
                  ImageLoader.shared.cancelLoad(token)
              }
            }
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.name = beers[indexPath.row].name!
        detailVC.imageUrlString = beers[indexPath.row].imageURL!
        detailVC.beerDescription = beers[indexPath.row].beerDescription!
        detailVC.ingredients = beers[indexPath.row].ingredients!
        detailVC.foodPairing = beers[indexPath.row].foodPairing!
        present(detailVC, animated: true)
    }
}

