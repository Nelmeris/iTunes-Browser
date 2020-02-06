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
    
    private var lastQuery: String?
    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private struct Constants {
        static let reuseAppCellIdentifier = "appReuseId"
        static let reuseSongCellIdentifier = "songReuseId"
    }
    
    private var searchType: SearchType = .apps {
        didSet {
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    private var searchAppResults: [AppCellModel] = [] {
        didSet {
            guard searchType == .apps else { return }
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    private var searchSongResults: [SongCellModel] = [] {
        didSet {
            guard searchType == .songs else { return }
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.configureUI()
        self.bindViewModel()
    }
    
    private func configureUI() {
        configureSearchBar()
        configureTableView()
    }
    
    private func bindViewModel() {
        // Во время загрузки данных показываем индикатор загрузки
        self.viewModel.isLoading.addObserver(self) { [weak self] (isLoading, _) in
            self?.throbber(show: isLoading)
        }
        // Если пришла ошибка, то отобразим ее в виде алерта
        self.viewModel.error.addObserver(self) { [weak self] (error, _) in
            if let error = error {
                self?.showError(error: error)
            }
        }
        // Если вью-модель указывает, что нужно показать экран пустых результатов, то делаем это
        self.viewModel.showEmptyResults.addObserver(self) { [weak self] (showEmptyResults, _) in
            self?.searchView.emptyResultView.isHidden = !showEmptyResults
            self?.searchView.tableView.isHidden = showEmptyResults
        }
        self.viewModel.searchType.addObserver(self) { [weak self] (searchType, _) in
            self?.searchType = searchType
        }
        // При обновлении данных, которые нужно отображать в ячейках, сохраняем их и перезагружаем tableView
        self.viewModel.appCellModels.addObserver(self) { [weak self] (searchResults, _) in
            self?.searchAppResults = searchResults
        }
        // При обновлении данных, которые нужно отображать в ячейках, сохраняем их и перезагружаем tableView
        self.viewModel.songCellModels.addObserver(self) { [weak self] (searchResults, _) in
            self?.searchSongResults = searchResults
        }
    }
    
    private func configureSearchBar() {
        self.searchView.searchBar.delegate = self
        self.searchView.searchBar.scopeButtonTitles = ["Apps", "Music"]
        self.searchView.searchBar.showsScopeBar = true
    }
    
    private func configureTableView() {
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseAppCellIdentifier)
        self.searchView.tableView.register(SongCell.self, forCellReuseIdentifier: Constants.reuseSongCellIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
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

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .apps:
            return searchAppResults.count
        case .songs:
            return searchSongResults.count
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
        guard let cell = dequeuedCell as? AppCell else { return dequeuedCell }
        let app = self.searchAppResults[indexPath.row]
        let cellModel = AppCellModelFactory.cellModel(from: app)
        cell.configure(with: cellModel)
        return cell
    }
    
    private func makeSongCell(for tableView: UITableView, on indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseSongCellIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? SongCell else {
            return dequeuedCell
        }
        let song = self.searchSongResults[indexPath.row]
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
            let app = self.viewModel.appCellModels.value[indexPath.row]
            self.viewModel.didSelectApp(app)
        case .songs:
            let song = self.viewModel.songCellModels.value[indexPath.row]
            self.viewModel.didSelectSong(song)
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
        self.viewModel.search(for: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.viewModel.didChangeSearchType(selectedScope)
    }
}
