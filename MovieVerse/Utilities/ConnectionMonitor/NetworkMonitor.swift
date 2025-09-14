//
//  NetworkMonitor.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation
import Network

/// A singleton class that monitors network connectivity status and publishes real-time updates.
final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    @Published private(set) var isConnected: Bool = false
    private(set) var connectionType: NWInterface.InterfaceType?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied

            if let interface = path.availableInterfaces.first(where: { path.usesInterfaceType($0.type) }) {
                self?.connectionType = interface.type
            } else {
                self?.connectionType = nil
            }
        }
        monitor.start(queue: queue)
    }
}

// MARK: - ConnectionMonitor

extension NetworkMonitor: ConnectionMonitor {
    var isConnectedPublisher: Published<Bool>.Publisher {
        $isConnected
    }
}
