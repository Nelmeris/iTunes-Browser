//
//  SearchPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Elena Gracheva on 27.01.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit


protocol SearchViewInput: class {
    
    var searchAppsResults: [ITunesApp] { get set }
    var searchSongsResults: [ITunesSong] { get set }
    var searchType: SearchType { get set }
    
    func showError(error: Error)
    
    func showNoResults()
    
    func hideNoResults()
    
    func throbber(show: Bool)
}


protocol SearchViewOutput: class {
    func viewDidSearch(with query: String)
    
    func viewDidSelectApp(_ app: ITunesApp)
    func viewDidSelectSong(_ song: ITunesSong)
    
    func viewDidSelectSearchScope(_ selectedScope: Int)
}


enum SearchType: Int {
    case apps
    case songs
}


class SearchPresenter {

    weak var viewInput: (UIViewController & SearchViewInput)?
    
    private let searchService = ITunesSearchService()
    
    let interactor: SearchInteractorInput
    let router: SearchRouterInput

    init(interactor: SearchInteractorInput, router: SearchRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    private func requestApps(with query: String) {
        self.searchService.getApps(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            self.viewInput?.throbber(show: false)
            result
                .withValue { apps in
                    guard !apps.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchAppsResults = apps
                }
                .withError {
                    self.viewInput?.showError(error: $0)
                }
        }
    }
    
    private func requestSongs(with query: String) {
        self.searchService.getSongs(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            self.viewInput?.throbber(show: false)
            result
                .withValue { songs in
                    guard !songs.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchSongsResults = songs
                }
                .withError {
                    self.viewInput?.showError(error: $0)
                }
        }
    }
    
}

extension SearchPresenter: SearchViewOutput {

    func viewDidSearch(with query: String) {
        self.viewInput?.throbber(show: true)
        guard let type = self.viewInput?.searchType else { return }
        switch type {
        case .apps:
            self.requestApps(with: query)
        case .songs:
            self.requestSongs(with: query)
        }
    }

    func viewDidSelectApp(_ app: ITunesApp) {
        self.router.openAppDetails(for: app)
    }
    
    func viewDidSelectSong(_ song: ITunesSong) {
        // TODO
    }
    
    func viewDidSelectSearchScope(_ selectedScope: Int) {
        self.viewInput?.searchType = SearchType(rawValue: selectedScope)!
    }

}
