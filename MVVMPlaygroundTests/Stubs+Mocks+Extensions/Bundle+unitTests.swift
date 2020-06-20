//
//  Bundle+unitTests.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 6/14/20.
//  Copyright © 2020 ysaddiq. All rights reserved.
//
import Foundation

extension Bundle {
    public class var unitTest: Bundle {
        return Bundle(for: PhotoListViewModelTests.self)
    }
}
