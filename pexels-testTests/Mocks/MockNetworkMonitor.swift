//
//  MockNetworkMonitor.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 04/07/24.
//

import Combine
@testable import pexels_test

class MockNetworkMonitor: NetworkMonitorProtocol {
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    private(set) var isConnected: Bool = true

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    func startMonitoring() { }

    func stopMonitoring() { }

    func simulateConnectionChange(to status: Bool) {
        isConnected = status
        isConnectedSubject.send(status)
    }
}
