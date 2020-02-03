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
        guard let app = app else { return }
        self.appDetailWhatsNewView.versionLabel.text = "Версия \(app.version)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: app.updateDate) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date, to: Date())
            self.appDetailWhatsNewView.updateDaysPassedLabel.text = "\(components.day ?? 0) дней назад"
        }
        self.appDetailWhatsNewView.updateDescriptionLabel.text = app.appDescription
    }
    
}
