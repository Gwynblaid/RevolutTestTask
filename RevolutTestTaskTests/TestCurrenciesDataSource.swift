// Copyright (C) ABBYY (BIT Software), 1993-2019 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import XCTest
@testable import RevolutTestTask

class TestCurrenciesDataSource: XCTestCase {
	
	let networkHelper = FakeNetworkHelper()
	var dataSource: DataSourceProtocol!
	let timeInterval: TimeInterval = 4
	
	lazy private var expectations = [XCTestExpectation(description: "1 Round"), XCTestExpectation(description: "2 round")]
	
	override func setUp() {
		super.setUp()
		dataSource = CurrenciesDataSource(networkHelper: networkHelper, refreshTimeInterval: timeInterval)
		dataSource.currentCurrency = Currency(code: "EUR")
		
	}
	
	func testCurrencies() {
		XCTAssert(dataSource.currentCurrency.code == "EUR", "Start state is EUR")
		dataSource.currentCurrency = Currency(code: "RUB")
		XCTAssert(dataSource.currentCurrency.code == "RUB", "Current currency should changed to RUB")
	}
	
	func testNumberOfSections () {
		XCTAssert(dataSource.numberOfSections == 0, "Number of sections should be equal to 0 if no data")
		let expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.dataSource.numberOfSections == 1, "Number of sections should be equal to 1 if data exist")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testTimerAndDelegate() {
		dataSource.delegate = self
		let expect = expectations.last!
		dataSource.loadData(completion: { _ in })
		wait(for: [expect], timeout: 10)
		let date = Date()
		wait(for: [expectations.last!], timeout: 10)
		XCTAssert(abs(Date().timeIntervalSince(date) - timeInterval) < 0.1, "Repeat timer should be around \(timeInterval)")
	}
	
	func testRowsInSection() {
		XCTAssert(dataSource.rows(in: 2) == 0, "Rows count for not existing section should be equal zero")
		let expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.networkHelper.ratesCount == self.dataSource.rows(in: 0), "Rows should be equal to count of rates currencies")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testLoadData() {
		var expectation = XCTestExpectation(description: "Load complete")
		dataSource.loadData { result in
			XCTAssert(result, "Should return true for valid data")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
		
		
		expectation = XCTestExpectation(description: "Load complete")
		dataSource.currentCurrency = Currency(code: "US")
		dataSource.loadData { result in
			XCTAssert(!result, "Should return false for error")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testSectionInfo() {
		XCTAssert(dataSource.sectionInfo(for: 2) == nil, "Section info for not existing section should be equal nil")
		let expectation = XCTestExpectation(description: "Data load")
		dataSource.loadData { [unowned self] _ in
			XCTAssert(self.dataSource.sectionInfo(for: 0) == nil, "Section info for all sections should be equal nil")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
	
	func testCellMode() {
		XCTAssert(dataSource.cellModel(for: IndexPath(row: 0, section: 0)) == nil, "CellModel for not existing index path should be equal nil")
		let expectation = XCTestExpectation(description: "Data load")
		dataSource.loadData { [unowned self] _ in
			for i in 0..<self.networkHelper.ratesCount {
				XCTAssert(self.dataSource.cellModel(for: IndexPath(row: i, section: 0)) != nil, "CellModel should exist for all currencies rates")
			}
			XCTAssert(self.dataSource.cellModel(for: IndexPath(row: self.networkHelper.ratesCount, section: 0)) == nil, "CellModel for not existing index path should be equal nil")
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}
}

extension TestCurrenciesDataSource: DataSourceDelegate {
	func dataReloaded() {
		let expect = expectations.removeLast()
		expect.fulfill()
	}
}
