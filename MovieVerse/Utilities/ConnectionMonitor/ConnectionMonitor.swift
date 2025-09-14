//
//  ConnectionMonitor.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//
import Combine
import Foundation

protocol ConnectionMonitor: ObservableObject {
    var isConnected: Bool { get }
    var isConnectedPublisher: Published<Bool>.Publisher { get }
}
