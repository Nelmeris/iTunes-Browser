//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    public var app: ITunesApp?
    
    
    var headerViewController: AppDetailHeaderViewController!
    var whatsNewViewController: AppDetailWhatsNewViewController!
    
    private let imageDownloader = ImageDownloader()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        headerViewController = AppDetailHeaderViewController(app: self.app!)
        whatsNewViewController = AppDetailWhatsNewViewController(app: self.app!)
        self.configureNavigationController()
        self.addHeaderViewController()
        self.addWhatsNewViewController()
    }
    
    // MARK: - Private
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func addHeaderViewController() {
        self.addChild(self.headerViewController)
        self.view.addSubview(self.headerViewController.view)
        self.headerViewController.didMove(toParent: self)
        
        self.headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.headerViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    }
    
    private func addWhatsNewViewController() {
        self.addChild(self.whatsNewViewController)
        self.view.addSubview(self.whatsNewViewController.view)
        self.whatsNewViewController.didMove(toParent: self)
        
        self.whatsNewViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whatsNewViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.bottomAnchor),
            self.whatsNewViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.whatsNewViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
}
