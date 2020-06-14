//
//  PhotoListViewModel.swift
//  MVVMPlayground
//
//  Created by Neo on 03/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

class PhotoListViewModel {
    
    let apiService: APIServiceProtocol

    private var photos: [Photo] = [Photo]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedPhoto: Photo?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        state = .loading
        apiService.fetchPopularPhoto { [weak self] (photos, error) in
            guard let self = self else {
                return
            }

            guard error == nil,
                let photos = photos else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }

            self.processFetchedPhoto(photos: photos)
            self.state = .populated
        }
    }

    private func processFetchedPhoto(photos: [Photo]) {
        self.photos = photos // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append(createCellViewModel(photo: photo))
        }
        self.cellViewModels = vms
    }
    
    func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {

        //Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append(description)
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return PhotoListCellViewModel(titleText: photo.name,
                                      descText: desc,
                                      imageUrl: photo.image_url,
                                      dateText: dateFormatter.string(from: photo.created_at))
    }

    func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

extension PhotoListViewModel {
    func userPressed(at indexPath: IndexPath){
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        } else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.alertMessage = "This item is not for sale"
        }
    }
}
