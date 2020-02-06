//
//  SearchModuleBuilder.swift
//  iOSArchitecturesDemo
//
//  Created by Elena Gracheva on 27.01.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit

final class SearchModuleBuilder {
    
    static func build() -> UIViewController {
        let searchService = ITunesSearchService()
        let downloadAppsService = FakeDownloadAppsService()
        let viewModel = SearchViewModel(searchService: searchService, downloadAppsService: downloadAppsService)
        let viewController = SearchViewController(viewModel: viewModel)
        viewModel.viewController = viewController
        return viewController
    }
    
}
