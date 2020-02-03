//
//  AppDetailWhatsNewView.swift
//  iTunes Apps
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit

class AppDetailWhatsNewView : UIView {
    
    // MARK: - Subviews
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что нового"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private(set) lazy var versionHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("История версий", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentEdgeInsets = .zero
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
    private(set) lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) lazy var updateDaysPassedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .lightGray
        return label
    }()
    
    private(set) lazy var updateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    // MARK: - UI
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.versionHistoryButton)
        self.addSubview(self.versionLabel)
        self.addSubview(self.updateDaysPassedLabel)
        self.addSubview(self.updateDescriptionLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            
            self.versionHistoryButton.leftAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.rightAnchor, constant: 20.0),
            self.versionHistoryButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16.0),
            self.versionHistoryButton.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            
            self.versionLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.versionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16.0),
            
            self.updateDaysPassedLabel.centerYAnchor.constraint(equalTo: self.versionLabel.centerYAnchor),
            self.updateDaysPassedLabel.rightAnchor.constraint(equalTo: self.versionHistoryButton.rightAnchor),
            
            self.updateDescriptionLabel.topAnchor.constraint(equalTo: self.versionLabel.bottomAnchor, constant: 15.0),
            self.updateDescriptionLabel.leftAnchor.constraint(equalTo: self.versionLabel.leftAnchor),
            self.updateDescriptionLabel.rightAnchor.constraint(equalTo: self.updateDaysPassedLabel.rightAnchor),
            self.updateDescriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 16.0)
            ])
    }
    
}
