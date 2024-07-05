//
//  NetworkMonitorTests.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 04/07/24.
//

import XCTest
import Combine
@testable import pexels_test

class NetworkMonitorTests: XCTestCase {
    var mockNetworkMonitor: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkMonitor = MockNetworkMonitor()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        mockNetworkMonitor = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialConnectionStatus() {
        let expectation = XCTestExpectation(
            description: "Initial connection status should be true"
        )

        mockNetworkMonitor.isConnectedPublisher
            .sink { isConnected in
                XCTAssertTrue(isConnected, "Initial connection status should be true")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSimulateConnectionChangeToFalse() {
        let expectation = XCTestExpectation(
            description: "Connection status should change to false"
        )

        mockNetworkMonitor.isConnectedPublisher
            .dropFirst()
            .sink { isConnected in
                XCTAssertFalse(isConnected, "Connection status should be false")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: false)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSimulateConnectionChangeToTrue() {
        let expectation = XCTestExpectation(
            description: "Connection status should change to true"
        )

        mockNetworkMonitor.simulateConnectionChange(to: false)

        mockNetworkMonitor.isConnectedPublisher
            .dropFirst()
            .sink { isConnected in
                if isConnected {
                    XCTAssertTrue(isConnected, "Connection status should be true")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: true)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSimulateMultipleConnectionChanges() {
        let expectation = XCTestExpectation(
            description: "Connection status should change to true, then to false, and then back to true"
        )

        var valuesReceived: [Bool] = []

        mockNetworkMonitor.simulateConnectionChange(to: false)

        mockNetworkMonitor.isConnectedPublisher
            .dropFirst()
            .sink { isConnected in
                valuesReceived.append(isConnected)
                if valuesReceived == [true, false, true] {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: true)
        mockNetworkMonitor.simulateConnectionChange(to: false)
        mockNetworkMonitor.simulateConnectionChange(to: true)

        wait(for: [expectation], timeout: 1.0)
    }

    func testMultipleSubscribers() {
        let expectation1 = XCTestExpectation(
            description: "First subscriber expecting connection status change to false"
        )
        let expectation2 = XCTestExpectation(
            description: "Second subscriber expecting connection status change to false"
        )

        mockNetworkMonitor.isConnectedPublisher
            .dropFirst()
            .sink { isConnected in
                XCTAssertFalse(isConnected, "First subscriber: Connection status should be false")
                expectation1.fulfill()
            }
            .store(in: &cancellables)

        mockNetworkMonitor.isConnectedPublisher
            .dropFirst()
            .sink { isConnected in
                XCTAssertFalse(isConnected, "Second subscriber: Connection status should be false")
                expectation2.fulfill()
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: false)

        wait(for: [expectation1, expectation2], timeout: 1.0)
    }

    func testSubscriberReceivesCurrentValue() {
        let expectation = XCTestExpectation(
            description: "Subscriber should receive the current value immediately"
        )

        mockNetworkMonitor.startMonitoring()

        mockNetworkMonitor.isConnectedPublisher
            .sink { isConnected in
                XCTAssertTrue(isConnected, "Subscriber should receive the current value which is true")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
