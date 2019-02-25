// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import XCTest
@testable import RevolutTestTask

class TestCurrenciesDataSource: XCTestCase {
	
	let networkHelper = FakeNetworkHelper()
	var dataSource: CurrencyInteractor!
	let timeInterval: TimeInterval = 4
	
	override func setUp() {
		super.setUp()
		dataSource = CurrencyViewControllerInteractor(networkHelper: networkHelper, refreshTimeInterval: timeInterval)
	}
	
	func testNumberOfSections () {
		XCTAssert(dataSource.numberOfSections == 1, "Number of sections should be equal to 0 if no data")
		let expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.dataSource.numberOfSections == 2, "Number of sections should be equal to 1 if data exist")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testRowsInSection() {
		XCTAssert(dataSource.rows(in: 2) == 0, "Rows count for not existing section should be equal zero")
		let expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.networkHelper.ratesCount == self.dataSource.rows(in: 1), "Rows should be equal to count of rates currencies")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testLoadData() {
		let expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { result in
			XCTAssert(result, "Should return true for valid data")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
    }
	
	func testSectionInfo() {
		XCTAssert(dataSource.sectionInfo(for: 2) == nil, "Section info for not existing section should be equal nil")
		let expectation = XCTestExpectation(description: "Data load")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.dataSource.sectionInfo(for: 0) == nil, "Section info for all sections should be equal nil")
            XCTAssert(self.dataSource.sectionInfo(for: 1) == nil, "Section info for all sections should be equal nil")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testCellMode() {
		XCTAssert(dataSource.cellModel(for: IndexPath(row: 0, section: 1)) == nil, "CellModel for not existing index path should be equal nil")
		let expectation = XCTestExpectation(description: "Data load")
		dataSource.loadData { [unowned self] _ in
			for i in 0..<self.networkHelper.ratesCount {
				XCTAssert(self.dataSource.cellModel(for: IndexPath(row: i, section: 1)) != nil, "CellModel should exist for all currencies rates")
			}
			XCTAssert(self.dataSource.cellModel(for: IndexPath(row: self.networkHelper.ratesCount, section: 0)) == nil, "CellModel for not existing index path should be equal nil")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
        XCTAssert(dataSource.cellModel(for: IndexPath(row: 0, section: 0)) != nil, "CellModel should exist for (0;0)")
        XCTAssert(dataSource.cellModel(for: IndexPath(row: 1, section: 0)) == nil, "CellModel for not existing index path should be equal nil")
	}
}
