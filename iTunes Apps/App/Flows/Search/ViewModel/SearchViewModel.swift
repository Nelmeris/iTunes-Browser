//
//  SearchViewModel.swift
//  iTunes Apps
//
//  Created by Artem Kufaev on 06.02.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit

enum SearchType: Int {
    case apps
    case songs
}

final class SearchViewModel {

// MARK: - Observable properties
    
    let appCellModels = Observable<[AppCellModel]>([])
    let songCellModels = Observable<[SongCellModel]>([])
    let isLoading = Observable<Bool>(false)
    let showEmptyResults = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    let searchType = Observable<SearchType>(.apps)

    // MARK: - Properties

    weak var viewController: UIViewController?
    
    private var apps: [ITunesApp] = []
    private var songs: [ITunesSong] = []

    private let searchService: SearchServiceInterface
    private let downloadAppsService: DownloadAppsServiceInterface

    // MARK: - Init

    init(searchService: SearchServiceInterface, downloadAppsService: DownloadAppsServiceInterface) {
        self.searchService = searchService
        self.downloadAppsService = downloadAppsService
        downloadAppsService.onProgressUpdate = { [weak self] in
            guard let self = self else { return }
            self.appCellModels.value = self.appViewModels()
        }
    }

// MARK: - ViewModel methods

    func search(for query: String) {
        self.isLoading.value = true
        switch searchType.value {
        case .apps:
            self.searchService.getApps(forQuery: query) { [weak self] result in
                guard let self = self else { return }
                result
                    .withValue { apps in
                        self.apps = apps
                        self.appCellModels.value = self.appViewModels()
                        self.isLoading.value = false
                        self.showEmptyResults.value = apps.isEmpty
                        self.error.value = nil
                    }
                    .withError {
                        self.apps = []
                        self.appCellModels.value = []
                        self.isLoading.value = false
                        self.showEmptyResults.value = true
                        self.error.value = $0
                }
            }
        case .songs:
            self.searchService.getSongs(forQuery: query) { [weak self] result in
                guard let self = self else { return }
                result
                    .withValue { songs in
                        self.songs = songs
                        self.songCellModels.value = self.songViewModels()
                        self.isLoading.value = false
                        self.showEmptyResults.value = songs.isEmpty
                        self.error.value = nil
                    }
                    .withError {
                        self.apps = []
                        self.appCellModels.value = []
                        self.isLoading.value = false
                        self.showEmptyResults.value = true
                        self.error.value = $0
                }
            }
        }
    }
    
    func didSelectApp(_ appViewModel: AppCellModel) {
        guard let app = self.app(with: appViewModel) else { return }
        let appDetaillViewController = AppDetailViewController(app: app)
        self.viewController?.navigationController?.pushViewController(appDetaillViewController, animated: true)
    }
    
    func didSelectSong(_ songViewModel: SongCellModel) {
        guard let song = self.song(with: songViewModel) else { return }
        dump(song)
    }
    
    func didTapDownloadApp(_ appViewModel: AppCellModel) {
        guard let app = self.app(with: appViewModel) else { return }
        self.downloadAppsService.startDownloadApp(app)
    }
    
    func didChangeSearchType(_ type: Int) {
        guard let type = SearchType(rawValue: type) else { return }
        self.searchType.value = type
    }
    
    // MARK: - Private
    
    private func appViewModels() -> [AppCellModel] {
        return self.apps.compactMap { app -> AppCellModel in
            let downloadingApp = self.downloadAppsService.downloadingApps.first { downloadingApp -> Bool in
                return downloadingApp.app.appName == app.appName
            }
            return AppCellModel(appName: app.appName,
                                      company: app.company,
                                      averageRating: app.averageRating,
                                      downloadState: downloadingApp?.downloadState ?? .notStarted)
        }
    }
    
    private func songViewModels() -> [SongCellModel] {
        return self.songs.compactMap { song -> SongCellModel in
            return SongCellModel(trackName: song.trackName,
                                 artistName: song.artistName,
                                 collectionName: song.collectionName)
        }
    }
    
    private func app(with viewModel: AppCellModel) -> ITunesApp? {
        return self.apps.first { viewModel.appName == $0.appName }
    }
    
    private func song(with viewModel: SongCellModel) -> ITunesSong? {
        return self.songs.first { viewModel.trackName == $0.trackName && viewModel.artistName == $0.artistName }
    }
}
