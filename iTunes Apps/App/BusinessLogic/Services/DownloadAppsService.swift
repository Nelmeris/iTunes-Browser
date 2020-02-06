//
//  DownloadAppsService.swift
//  iTunes Apps
//
//  Created by Artem Kufaev on 06.02.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import Foundation

protocol DownloadAppsServiceInterface: class {
    var downloadingApps: [DownloadingApp] { get }
    var onProgressUpdate: (() -> Void)? { get set }
    func startDownloadApp(_ app: ITunesApp)
}

final class DownloadingApp {
    enum DownloadState {
        case notStarted
        case inProgress(progress: Double)
        case downloaded
    }
    
    let app: ITunesApp
    
    var downloadState: DownloadState = .notStarted
    
    init(app: ITunesApp) {
        self.app = app
    }
}

final class FakeDownloadAppsService: DownloadAppsServiceInterface {
    
    // MARK: - DownloadAppsServiceInterface
    
    private(set) var downloadingApps: [DownloadingApp] = []
    
    var onProgressUpdate: (() -> Void)?
    
    func startDownloadApp(_ app: ITunesApp) {
        let downloadingApp = DownloadingApp(app: app)
        if !self.downloadingApps.contains(where: { $0.app.appName == app.appName }) {
            self.downloadingApps.append(downloadingApp)
            self.startTimer(for: downloadingApp)
        }
    }
    
    // MARK: - Private properties
    
    private var timers: [Timer] = []
    
    // MARK: - Private
    
    private func startTimer(for downloadingApp: DownloadingApp) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            switch downloadingApp.downloadState {
            case .notStarted:
                downloadingApp.downloadState = .inProgress(progress: 0.05)
            case .inProgress(let progress):
                let newProgress = progress + 0.05
                if newProgress >= 1 {
                    downloadingApp.downloadState = .downloaded
                    self?.invalidateTimer(timer)
                } else {
                    downloadingApp.downloadState = .inProgress(progress: progress + 0.05)
                }
            case .downloaded:
                self?.invalidateTimer(timer)
            }
            self?.onProgressUpdate?()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timers.append(timer)
    }
    
    private func invalidateTimer(_ timer: Timer) {
        timer.invalidate()
        self.timers.removeAll { $0 === timer }
    }
}

