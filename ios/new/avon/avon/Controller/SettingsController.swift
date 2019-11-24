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
    var commands = ["Call", "Text", "Reminder", "Speed Warnings"]
    var tableView: UITableView?
    var hintLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let titleView = UILabel(frame: CGRect(x: 35, y: 20, width: self.view.bounds.width - 35, height: 100))
        titleView.font = UIFont.boldSystemFont(ofSize: 32.0)
        titleView.text = "Commands"
        self.view.addSubview(titleView)
        
        hintLabel = UILabel(frame: CGRect(x: 0, y: -65, width: self.view.bounds.width, height: 100))
        hintLabel?.font = UIFont.systemFont(ofSize: 11.0)
        hintLabel?.text = "PULL UP FOR SETTINGS"
        hintLabel?.textAlignment = .center
        hintLabel?.alpha = 0.4
        hintLabel?.textColor = .white
        
        self.view.addSubview(titleView)
        self.view.addSubview(hintLabel!)
        
        tableView = UITableView(frame: CGRect(x: 21, y: 105, width: self.view.bounds.width - 40, height: UIScreen.main.bounds.height - 105))

        self.view.addSubview(tableView!)
        tableView!.isScrollEnabled = false
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.rowHeight = 50
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
    
    override func pullUpControllerDidMove(to point: CGFloat) {
        if point > 40 {
            hintLabel?.text = "SWIPE DOWN TO CLOSE"
        } else {
            hintLabel?.text = "SWIPE UP FOR SETTINGS"
        }
    }
}


extension SettingsController: UITableViewDataSource {

    // Getting the amount of cells
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commands.count
      }
    
     @objc func switchChanged(_ sender : UISwitch!){
        // insert active command code here
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = commands[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        switchView.onTintColor = .black
    
        return cell
      }

}
