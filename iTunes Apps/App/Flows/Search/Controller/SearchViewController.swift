//
//  ViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 14.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let presenter: SearchViewOutput
    private var lastQuery: String?
    
    init(presenter: SearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private let searchService = ITunesSearchService()
    internal var searchAppsResults = [ITunesApp]() {
        didSet {
            guard searchType == .apps else { return }
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    internal var searchSongsResults = [ITunesSong]() {
        didSet {
            guard searchType == .songs else { return }
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    internal var searchType: SearchType = .apps {
        didSet {
            self.searchView.tableView.reloadData()
            guard let query = lastQuery else { return }
            self.presenter.viewDidSearch(with: query)
        }
    }
    
    private struct Constants {
        static let reuseAppCellIdentifier = "appReuseId"
        static let reuseSongCellIdentifier = "songReuseId"
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
        self.searchView.searchBar.scopeButtonTitles = ["Apps", "Music"]
        self.searchView.searchBar.showsScopeBar = true
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseAppCellIdentifier)
        self.searchView.tableView.register(SongCell.self, forCellReuseIdentifier: Constants.reuseSongCellIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        self.searchAppsResults.r
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }

    
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .apps:
            return searchAppsResults.count
        case .songs:
            return searchSongsResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .apps:
            return makeAppCell(for: tableView, on: indexPath)
        case .songs:
            return makeSongCell(for: tableView, on: indexPath)
        }
    }
    
    private func makeAppCell(for tableView: UITableView, on indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseAppCellIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? AppCell else {
            return dequeuedCell
        }
        let app = self.searchAppsResults[indexPath.row]
        let cellModel = AppCellModelFactory.cellModel(from: app)
        cell.configure(with: cellModel)
        return cell
    }
    
    private func makeSongCell(for tableView: UITableView, on indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseSongCellIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? SongCell else {
            return dequeuedCell
        }
        let song = self.searchSongsResults[indexPath.row]
        let cellModel = SongCellModelFactory.cellModel(from: song)
        cell.configure(with: cellModel)
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch searchType {
        case .apps:
            let app = searchAppsResults[indexPath.row]
            self.presenter.viewDidSelectApp(app)
        case .songs:
            let song = searchSongsResults[indexPath.row]
            self.presenter.viewDidSelectSong(song)
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        self.lastQuery = query
        self.presenter.viewDidSearch(with: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.presenter.viewDidSelectSearchScope(selectedScope)
    }
}

extension SearchViewController: SearchViewInput {
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResults() {
        self.searchView.emptyResultView.isHidden = false
    }
    
    func hideNoResults() {
        self.searchView.emptyResultView.isHidden = true
    }
    
    func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}
