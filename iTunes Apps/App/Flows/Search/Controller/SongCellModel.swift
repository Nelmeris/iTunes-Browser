//
//  SongCellModel.swift
//  iTunes Apps
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import Foundation

struct SongCellModel {
    let trackName: String
    let artistName: String?
    let collectionName: String?
}

final class SongCellModelFactory {
    
    static func cellModel(from model: SongCellModel) -> SongCellModel {
        return SongCellModel(trackName: model.trackName, artistName: model.artistName, collectionName: model.collectionName)
    }
}
