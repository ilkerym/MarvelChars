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
    private let activityIndicator = UIActivityIndicatorView()
    
    var characterID = Int()
    var urlForComics : String?
    var requestForDetail = APIRequest(offset: 0)
    var requestForComic = APIRequest(offset: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign protocols to controller
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.backgroundColor = .black
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showSpinner()
        
        
        if let description = charDescription {
            
            if description.isEmpty {
                charDescriptionLabel.text = "No Available Description"
            } else {
                charDescriptionLabel.text = description
            }
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        guard let urll = urlForComics else {return print("error")}
        
        
        requestForComic.fetchComics(Url: urll) { response in
            switch response {
                
            case .success(let data):
                self.comicsSummary = data
                DispatchQueue.main.async {
                    self.detailsTableView.reloadData()
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
            
            
            self.removeSpinner()
        }
        
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
        
        detailsTableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
    }
    private func removeSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    //    func loadComics(Url: String, onComplete : @escaping (Result<[Comic], AFError>) -> Void){
    //
    //       let decoder = JSONDecoder()
    //        decoder.dateDecodingStrategy = .iso8601
    //
    //        AF.request(Url, parameters: requestForComic.parametersForComic ).responseDecodable(of: ComicDataModel.self, decoder: decoder) { response in
    //
    //
    //            switch response.result {
    //
    //            case .success(let responseData):
    //                //print(response)
    //                if let result = responseData.data?.results {
    //                    onComplete(.success(result))
    //                }
    //            case .failure(let err):
    //                onComplete(.failure(err))
    //                print(err)
    //            }
    //        }
    //    }
}

// MARK: - Details Table View Data Source Method
extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comicsSummary.isEmpty ? 1 : comicsSummary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailsTableViewCell

        if comicsSummary.isEmpty {
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if comicsSummary.isEmpty {
                cell.comicName = "No Available Comic"
            }
        } else {
            if let title = comicsSummary[indexPath.row].title {
                cell.comicName = title
            }
            else {
                print("while unwrapping comic name error occured")
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






