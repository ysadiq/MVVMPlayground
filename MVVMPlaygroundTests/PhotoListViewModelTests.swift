//
//  PhotoListViewModelTests.swift
//  MVVMPlaygroundTests
//
//  Created by Neo on 03/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import XCTest
@testable import MVVMPlayground

class PhotoListViewModelTests: XCTestCase {
    
    var sut: PhotoListViewModel!
    var apiServiceMock: ApiServiceMock!

    override func setUp() {
        super.setUp()
        apiServiceMock = ApiServiceMock()
        sut = PhotoListViewModel(apiService: apiServiceMock)
    }
    
    override func tearDown() {
        sut = nil
        apiServiceMock = nil
        super.tearDown()
    }
    
    func test_fetch_photo() {
        // Given
        apiServiceMock.completePhotos = [Photo]()

        // When
        sut.initFetch()
    
        // Assert
        XCTAssert(apiServiceMock!.isFetchPopularPhotoCalled)
    }
    
    func test_fetch_photo_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied
        
        // When
        sut.initFetch()
        
        apiServiceMock.fetchFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }
    
    func test_create_cell_view_model() {
        // Given
        let photos = StubGenerator().stubPhotos()
        apiServiceMock.completePhotos = photos
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            expect.fulfill()
        }
        
        // When
        sut.initFetch()
        apiServiceMock.fetchSuccess()
        
        // Number of cell view model is equal to the number of photos
        XCTAssertEqual( sut.numberOfCells, photos.count )
        
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)
        
    }
    
    func test_populated_state_when_fetching() {
        
        //Given
        var state: State = .empty
        let expect = XCTestExpectation(description: "Loading state updated to populated")
        sut.updateLoadingStatus = { [weak sut] in
            state = sut!.state
            expect.fulfill()
        }
        
        //when fetching
        sut.initFetch()
        
        // Assert
        XCTAssertEqual(state, State.loading)

        // When finished fetching 
        apiServiceMock!.fetchSuccess()
        XCTAssertEqual(state, State.populated)

        wait(for: [expect], timeout: 1.0)
    }

    func test_error_state_when_fetching() {

        //Given
        var state: State = .empty
        let expect = XCTestExpectation(description: "Loading state updated to error")
        sut.updateLoadingStatus = { [weak sut] in
            state = sut!.state
            expect.fulfill()
        }
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied

        //when fetching
        sut.initFetch()

        // Assert
        XCTAssertEqual(state, State.loading)

        // When finished fetching
        apiServiceMock!.fetchFail(error: error)
        XCTAssertEqual(state, State.error)

        wait(for: [expect], timeout: 1.0)
    }
    
    func test_user_press_for_sale_item() {
        
        //Given a sut with fetched photos
        let indexPath = IndexPath(row: 0, section: 0)
        goToFetchPhotoFinished()

        //When
        sut.userPressed( at: indexPath )
        
        //Assert
        XCTAssertTrue( sut.isAllowSegue )
        XCTAssertNotNil( sut.selectedPhoto )
        
    }
    
    func test_user_press_not_for_sale_item() {
        
        //Given a sut with fetched photos
        let indexPath = IndexPath(row: 4, section: 0)
        goToFetchPhotoFinished()
        
        let expect = XCTestExpectation(description: "Alert message is shown")
        sut.showAlertClosure = { [weak sut] in
            expect.fulfill()
            XCTAssertEqual(sut!.alertMessage, "This item is not for sale")
        }
        
        //When
        sut.userPressed( at: indexPath )
        
        //Assert
        XCTAssertFalse( sut.isAllowSegue )
        XCTAssertNil( sut.selectedPhoto )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_get_cell_view_model() {
        
        //Given a sut with fetched photos
        goToFetchPhotoFinished()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testPhoto = apiServiceMock.completePhotos[indexPath.row]
        
        // When
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.titleText, testPhoto.name)
        
    }
    
    func test_cell_view_model() {
        //Given photos
        let today = Date()
        let photo = Photo(id: 1, name: "Name", description: "desc", created_at: today, image_url: "url", for_sale: true, camera: "camera")
        let photoWithoutCarmera = Photo(id: 1, name: "Name", description: "desc", created_at: Date(), image_url: "url", for_sale: true, camera: nil)
        let photoWithoutDesc = Photo(id: 1, name: "Name", description: nil, created_at: Date(), image_url: "url", for_sale: true, camera: "camera")
        let photoWithouCameraAndDesc = Photo(id: 1, name: "Name", description: nil, created_at: Date(), image_url: "url", for_sale: true, camera: nil)
        
        // When creat cell view model
        let cellViewModel = sut!.createCellViewModel( photo: photo )
        let cellViewModelWithoutCamera = sut!.createCellViewModel( photo: photoWithoutCarmera )
        let cellViewModelWithoutDesc = sut!.createCellViewModel( photo: photoWithoutDesc )
        let cellViewModelWithoutCameraAndDesc = sut!.createCellViewModel( photo: photoWithouCameraAndDesc )
        
        // Assert the correctness of display information
        XCTAssertEqual( photo.name, cellViewModel.titleText )
        XCTAssertEqual( photo.image_url, cellViewModel.imageUrl )
        
        XCTAssertEqual(cellViewModel.descText, "\(photo.camera!) - \(photo.description!)" )
        XCTAssertEqual(cellViewModelWithoutDesc.descText, photoWithoutDesc.camera! )
        XCTAssertEqual(cellViewModelWithoutCamera.descText, photoWithoutCarmera.description! )
        XCTAssertEqual(cellViewModelWithoutCameraAndDesc.descText, "" )
        
        let year = Calendar.current.component(.year, from: today)
        let month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        
        XCTAssertEqual( cellViewModel.dateText, String(format: "%d-%02d-%02d", year, month, day) )
        
    }

}

//MARK: State control
extension PhotoListViewModelTests {
    private func goToFetchPhotoFinished() {
        apiServiceMock.completePhotos = StubGenerator().stubPhotos()
        sut.initFetch()
        apiServiceMock.fetchSuccess()
    }
}

