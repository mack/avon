//
//  SettingsController.swift
//  avon
//
//  Created by Mackenzie Boudreau & Jarret Terrio on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit

class SettingsController: PullUpController {

    public var portraitSize: CGSize = .zero
    var commands = ["Call", "Text", "Reminder", "temp"]
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let titleView = UILabel(frame: CGRect(x: 35, y: 20, width: self.view.bounds.width - 35, height: 100))
        titleView.font = UIFont.boldSystemFont(ofSize: 32.0)
        titleView.text = "Commands"
        self.view.addSubview(titleView)
        
        tableView = UITableView(frame: CGRect(x: 25, y: 120, width: self.view.bounds.width - 20, height: UIScreen.main.bounds.height - 120))
        self.view.addSubview(tableView!)
        tableView!.isScrollEnabled = false
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.rowHeight = 60
        tableView?.dataSource = self
        tableView?.separatorColor = .clear
        
        portraitSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 60.0
    }
}


extension SettingsController: UITableViewDataSource {

    // Getting the amount of cells
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commands.count
      }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = commands[indexPath.row]
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)
        cell.textLabel?.frame = CGRect(x: 25, y: 25, width: 30, height: 0)
    
        return cell
      }

}
