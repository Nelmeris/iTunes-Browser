//
//  AppCellModel.swift
//  iOSArchitecturesDemo
//
//  Created by Evgeny Kireev on 02/06/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

struct AppCellModel {
    let appName: String
    let company: String?
    let averageRating: Float?
    let downloadState: Observable<DownloadingApp.DownloadState>
}
