//
//  AppDetailWhatsNewViewController.swift
//  iTunes Apps
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 ekireev. All rights reserved.
//

import UIKit

class AppDetailWhatsNewViewController: UIViewController {
    
    public var app: ITunesApp?
        
    private var appDetailWhatsNewView: AppDetailWhatsNewView {
        return self.view as! AppDetailWhatsNewView
    }
    
    // MARK: - Init
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailWhatsNewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
    }
    
    // MARK: - Private
    
    private func fillData() {
        self.appDetailWhatsNewView.versionLabel.text = "Версия ..."
        self.appDetailWhatsNewView.updateDaysPassedLabel.text = "6 дней назад"
        self.appDetailWhatsNewView.updateDescriptionLabel.text = "..."
    }
    
}
