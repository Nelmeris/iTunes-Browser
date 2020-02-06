//
//  AppCell.swift
//  iOSArchitecturesDemo
//
//  Created by Evgeny Kireev on 01/03/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

final class AppCell: UITableViewCell {
    
    // MARK: - Subviews
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private(set) lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    private(set) lazy var downloadProgressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    private(set) lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Скачать", for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.addTarget(self, action: #selector(downloadPressed), for: .touchUpInside)
        button.layer.cornerRadius = 16.0
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Methods
    
    func configure(with cellModel: AppCellModel) {
        self.titleLabel.text = cellModel.appName
        self.subtitleLabel.text = cellModel.company
        self.ratingLabel.text = String(cellModel.averageRating ?? 0)
        cellModel.downloadState.addObserver(self) { state, _ in
            self.didDownloadStateChanged(state)
        }
    }
    
    private func didDownloadStateChanged(_ type: DownloadingApp.DownloadState) {
        switch type {
        case .notStarted:
            self.downloadProgressLabel.text = nil
        case .inProgress(let progress):
            let progressToShow = round(progress * 100.0) / 100.0
            self.downloadProgressLabel.text = "\(progressToShow)"
        case .downloaded:
            self.downloadProgressLabel.text = "Загружено"
        }
    }
    
    var onDownloadButtonType: (() -> ())?
    @objc func downloadPressed() {
        onDownloadButtonType?()
        downloadButton.isHidden = true
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [self.titleLabel, self.subtitleLabel, self.ratingLabel, self.downloadProgressLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        self.addTitleLabel()
        self.addSubtitleLabel()
        self.addRatingLabel()
        self.addDownloadProgressLabel()
        self.addDownloadButton()
    }
    
    private func addTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
            ])
    }
    
    private func addSubtitleLabel() {
        self.contentView.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4.0),
            self.subtitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.subtitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
            ])
    }
    
    private func addRatingLabel() {
        self.contentView.addSubview(self.ratingLabel)
        NSLayoutConstraint.activate([
            self.ratingLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 4.0),
            self.ratingLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.ratingLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
            ])
    }
    
    private func addDownloadProgressLabel() {
        self.contentView.addSubview(self.downloadProgressLabel)
        NSLayoutConstraint.activate([
            self.downloadProgressLabel.bottomAnchor.constraint(equalTo: self.ratingLabel.bottomAnchor),
            self.downloadProgressLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12.0)
            ])
    }
    
    private func addDownloadButton() {
        self.contentView.addSubview(self.downloadButton)
        NSLayoutConstraint.activate([
            self.downloadButton.bottomAnchor.constraint(equalTo: self.ratingLabel.bottomAnchor),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 100.0),
            self.downloadButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12.0)
            ])
    }
}
