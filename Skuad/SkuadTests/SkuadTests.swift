//
//  SkuadTests.swift
//  SkuadTests
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import XCTest
@testable import Skuad

class SkuadTests: XCTestCase {

    func testTrimFunctionality(){
        let output = "  sample  ".trim()
        XCTAssertEqual(output, "sample", "trim logic is incorrect")
    }
    
    func testEncodeFunctionality(){
        let output = "flower rose".encode()
        XCTAssertEqual(output, "flower%20rose", "encodeing logic is incorrect")
    }
    
    func testSuggestionSavingFunctionality(){
        UserDefaultHelper.addSuggestion(suggestion: "rose")
        UserDefaultHelper.addSuggestion(suggestion: "flower")
        UserDefaultHelper.addSuggestion(suggestion: "rose")
        
        let suggestionList = UserDefaultHelper.getSuggestionList()
        XCTAssertEqual(suggestionList.first, "rose", "add suggestion logic is incorrect")
        XCTAssertEqual(suggestionList[1], "flower", "add suggestion logic is incorrect")
        XCTAssertNotEqual(suggestionList[2], "rose", "add suggestion logic is incorrect")
    }
    
    func testParseImageListLogic(){
        let imageListJson = JsonHandler.readJson(fileName: "ImageList")
        let imageList = SearchHandler.parseImageList(json: imageListJson)
        
        XCTAssertNotNil(imageList)
        XCTAssertEqual(imageList?.totalImages, 500, "parsing logic is wrong")
        XCTAssertEqual(imageList?.images.count, 4, "parsing logic is incorrect")
        
        let image = imageList?.images.first
        XCTAssertEqual(image?.id, 324175, "parsing logic is incorrect")
        XCTAssertEqual(image?.downloads, 854755, "parsing logic is incorrect")
        XCTAssertEqual(image?.likes, 3178, "parsing logic is incorrect")
        XCTAssertEqual(image?.favorites, 2594, "parsing logic is incorrect")
        XCTAssertEqual(image?.userImageURL, "https://cdn.pixabay.com/user/2019/01/29/15-01-52-802_250x250.jpg", "parsing logic is incorrect")
    }
}
