//
//  SceneOperationTest.swift
//  KabuKit
//
//  Created by crexista on 2017/06/14.
//  Copyright © 2017年 crexi. All rights reserved.
//

import XCTest
@testable import KabuKit

class SceneOperationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_atで定義したScenarioがある場合はresolveで取得できる() {
        let operation = SceneOperation<MockStage>(stage: MockStage(), queue: DispatchQueue.main)
        
        operation.at(MockFirstScene.self) { (args) in }
        let scenario = operation.resolve(from: MockFirstScene())
        XCTAssertNotNil(scenario)
    }
    
    func test_atで定義したScenarioがない場合はresolveで取得できない() {
        let operation = SceneOperation<MockStage>(stage: MockStage(), queue: DispatchQueue.main)
        
        operation.at(MockFirstScene.self) { (s) in }
        let scenario = operation.resolve(from: MockSecondScene())
        XCTAssertNil(scenario)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
