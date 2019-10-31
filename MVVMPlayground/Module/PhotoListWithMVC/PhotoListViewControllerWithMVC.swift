//
//  PhotoListViewController(MVC).swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ST.Huang. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class PhotoListViewControllerWithMVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var photos: [Photo] = [Photo]()

    var selectedIndexPath: IndexPath?

    lazy var apiService: APIService = {
        return APIService()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Init the static view
        initView()

        // Fetch data from server
        initData()

    }

    func initView() {
        self.navigationItem.title = "Popular"

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    func initData() {
        // (problem #4: In addition, there’s another dependency, the API service, in the view controller.)
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            DispatchQueue.main.async {
                self?.photos = photos
                // (problem #2: when to start/stop the activity indicator.)
                self?.activityIndicator.stopAnimating()
                // (problem #3: We also have the View code such as the implementation of showing/hiding the table view)
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })

                self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension PhotoListViewControllerWithMVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCellWithMVC else {
            fatalError("Cell not exists in storyboard")
        }

        let photo = self.photos[indexPath.row]
        //Text
        cell.nameLabel.text = photo.name

        //Wrap a description
        var descText: [String] = [String]()
        if let camera = photo.camera {
            descText.append(camera)
        }
        if let description = photo.description {
            descText.append( description )
        }
        cell.descriptionLabel.text = descText.joined(separator: " - ")

        //Wrap the date (problem #1: The presentational logic such as converting Date to String)
        let dateFormateer = DateFormatter()
        dateFormateer.dateFormat = "yyyy-MM-dd"
        cell.dateLabel.text = dateFormateer.string(from: photo.created_at)

        //Image
        cell.mainImageView.sd_setImage(with: URL(string: photo.image_url), completed: nil)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.selectedIndexPath = indexPath
            return indexPath
        }else {
            let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return nil
        }
    }

}

extension PhotoListViewControllerWithMVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController,
            let indexPath = self.selectedIndexPath {
            let photo = self.photos[indexPath.row]
            vc.imageUrl = photo.image_url
        }
    }
}
