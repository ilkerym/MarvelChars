//
//  DetailsViewController.swift
//  MarvelChars
//
//  Created by İlker Yasin Memişoğlu on 22.02.2022.
//

import UIKit
import Alamofire


class DetailsViewController: UIViewController {
    
    // outlet definitions
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var charDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var charNameLabel: UILabel!
    
    // other parameters definitions
    var charLargeImage: UIImage?
    var charName: String?
    var charDescription : String?
    var comicsSummary = [Comic]()
    var hiddenForTableViewCell = true
    var characterId = Int()
    var comicUrl : String?
    var comicRequest = APIRequest(offset: 0)
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign protocols to controller
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.backgroundColor = .black
        initUI()
        showSpinner()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let description = charDescription {
            if description.isEmpty {
                charDescriptionLabel.text = "No Available Description"
            } else {
                charDescriptionLabel.text = description
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let urlForComic = comicUrl else {return print("error")}
        
        comicRequest.fetchDatas(Url: urlForComic, parameters: comicRequest.comicParameters) { response in
            switch response {

            case .success(let data):
                if data.isEmpty {
                                  self.hiddenForTableViewCell = false
                              } else {
                                  self.hiddenForTableViewCell = true
                                  self.comicsSummary = data as! [Comic]
                              }
                              DispatchQueue.main.async {
                                  self.detailsTableView.reloadData()
                                  self.removeSpinner()
                              }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//        comicRequest.fetchComics(Url: urlForComic) { response in
//            switch response {
//            case .success(let data):
//                if data.isEmpty {
//                    self.hiddenForTableViewCell = false
//                } else {
//                    self.hiddenForTableViewCell = true
//                    self.comicsSummary = data
//                }
//                DispatchQueue.main.async {
//                    self.detailsTableView.reloadData()
//                    self.removeSpinner()
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    private func initUI() {
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "Details"
        
        charNameLabel.text = charName
        characterImageView.image = charLargeImage
    }
    private func showSpinner() {
        activityIndicator.style = .medium
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        detailsTableView.backgroundView = activityIndicator
    }
    private func removeSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - Details Table View Data Source Methods
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !hiddenForTableViewCell ? 1 : comicsSummary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailsTableViewCell
        if !hiddenForTableViewCell {
            cell.comicName = "No Available Comic"
        } else {
            if let title = comicsSummary[indexPath.row].title {
                cell.comicName = title
            }
        }
        return cell
    }
}

// MARK: - Details Table View Delegate Methods
extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // to make tableview cells non-selectable
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Comics List"
        headerLabel.textColor = .systemBlue
        return headerLabel
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}






