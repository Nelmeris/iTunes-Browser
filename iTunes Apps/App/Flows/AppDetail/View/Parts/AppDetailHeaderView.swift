//
//  AppDetailHeaderView.swift
//  iOSArchitecturesDemo
//
//  Created by Elena Gracheva on 27.01.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit

class AppDetailHeaderView : UIView {
    
    // MARK: - Subviews
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 2
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var openButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Открыть", for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 16.0
        return button
    }()
    
    private(set) lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
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
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.openButton)
        self.addSubview(self.ratingLabel)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            self.imageView.widthAnchor.constraint(equalToConstant: 120.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 120.0),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16.0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12.0),
            self.subtitleLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.subtitleLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
            
            self.openButton.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16.0),
            self.openButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.openButton.widthAnchor.constraint(equalToConstant: 80.0),
            self.openButton.heightAnchor.constraint(equalToConstant: 32.0),
            
            self.ratingLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 24.0),
            self.ratingLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor),
            self.ratingLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            self.ratingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}
