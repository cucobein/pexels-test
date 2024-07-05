//
//  NetworkMonitor.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 04/07/24.
//

import Network

import Combine

protocol NetworkMonitorProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedSubject.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
