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
        // When
        sut.initFetch()
    
        // Then
        XCTAssert(apiServiceMock.isFetchPopularPhotoCalled)
    }
    
    func test_fetch_photo_fail() {
        // Given
        let error = APIError.permissionDenied

        // When
        sut.initFetch()
        apiServiceMock.fetchFail(error: error)

        // Then
        XCTAssertEqual(sut.alertMessage, error.localizedDescription)
    }

    func test_user_press_for_sale_item() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)

        apiServiceMock.completePhotos = StubGenerator().stubPhotos()

        sut.initFetch()
        apiServiceMock.fetchSuccess()

        // When
        sut.userPressed(at: indexPath)

        // Then
        XCTAssertTrue(sut.isAllowSegue)
    }

    func test_user_press_not_for_sale_item() {
        // Given
        let indexPath = IndexPath(row: 4, section: 0)

        apiServiceMock.completePhotos = StubGenerator().stubPhotos()

        sut.initFetch()
        apiServiceMock.fetchSuccess()

        let promise = XCTestExpectation(description: "Alert message is shown")
        sut.showAlertClosure = {
            promise.fulfill()
        }

        // When
        sut.userPressed(at: indexPath)
        wait(for: [promise], timeout: 1.0)

        // Then
        XCTAssertFalse(sut.isAllowSegue)
        XCTAssertNil(sut.selectedPhoto)
        XCTAssertEqual(sut.alertMessage, "This item is not for sale")
    }

    func test_create_cell_view_model() {
        // Given
        let photos = StubGenerator().stubPhotos()
        apiServiceMock.completePhotos = photos

        let promise = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableViewClosure = { () in
            promise.fulfill()
        }

        // When
        sut.initFetch()
        apiServiceMock.fetchSuccess()
        wait(for: [promise], timeout: 1.0)

        // Number of cell view model is equal to the number of photos
        XCTAssertEqual(sut.numberOfCells, photos.count)
    }

    func test_populated_state_when_fetching() {

        //Given
        var state: State = .empty
        let promise = XCTestExpectation(description: "Loading state updated to populated")
        sut.updateLoadingStatus = { [weak sut] in
            state = sut!.state
            promise.fulfill()
        }

        //when fetching
        sut.initFetch()
        wait(for: [promise], timeout: 1.0)

        // Assert
        XCTAssertEqual(state, State.loading)

        // When finished fetching
        apiServiceMock!.fetchSuccess()
        XCTAssertEqual(state, State.populated)
    }

    func test_error_state_when_fetching() {

        //Given
        var state: State = .empty
        let promise = XCTestExpectation(description: "Loading state updated to error")
        sut.updateLoadingStatus = { [weak sut] in
            state = sut!.state
            promise.fulfill()
        }
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied

        //when fetching
        sut.initFetch()
        wait(for: [promise], timeout: 1.0)

        // Assert
        XCTAssertEqual(state, State.loading)

        // When finished fetching
        apiServiceMock!.fetchFail(error: error)
        XCTAssertEqual(state, State.error)
    }

    func test_get_cell_view_model() {

        //Given a sut with fetched photos
        apiServiceMock.completePhotos = StubGenerator().stubPhotos()

        sut.initFetch()
        apiServiceMock.fetchSuccess()

        let indexPath = IndexPath(row: 1, section: 0)
        let testPhoto = apiServiceMock.completePhotos[indexPath.row]

        // When
        let vm = sut.getCellViewModel(at: indexPath)

        //Assert
        XCTAssertEqual(vm.titleText, testPhoto.name)
    }

    func test_cell_view_model() {
        // Given
        let today = Date()
        let photo = Photo(id: 1,
                          name: "Name",
                          description: "desc",
                          created_at: today,
                          image_url: "url",
                          for_sale: true,
                          camera: "camera")

        // When
        let cellViewModel = sut!.createCellViewModel(photo: photo)

        // Then
        XCTAssertEqual(cellViewModel.descText, "\(photo.camera!) - \(photo.description!)")
    }
}

