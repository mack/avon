//
//  SettingsController.swift
//  avon
//
//  Created by Mackenzie Boudreau & Jarret Terrio on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit

var Commands = [
    Command(name: "Call", active: false, fn: nil),
    Command(name: "Text", active: true, fn: nil),
    Command(name: "Reminder", active: false, fn: nil),
    Command(name: "Speed Warnings", active: true, fn: nil),
    Command(name: "Current Time", active: true, fn: nil),
]

var Extensions = [
    Extension(name: "Discord", description: "", price: 0.99),
    Extension(name: "Slack", description: "", price: 0.99),
    Extension(name: "Dangerous Areas", description: "", price: 0),
    Extension(name: "Traffic Detector", description: "", price: 0),
    Extension(name: "Upcoming crosswalk", description: "", price: 0),
    Extension(name: "Email Notifier", description: "", price: 0),
]

var apps = ["Discord", "Email Notifier", "Slack", "Dangerous Areas", "Crosswalk Detector"]

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class SettingsController: PullUpController {

    public var portraitSize: CGSize = .zero
    var commandTableView: UITableView?

    var hintLabel: UILabel?
    var pageControl: UIPageControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        pageControl?.pageIndicatorTintColor = UIColor.init(red: 214, green: 214, blue: 214)
        pageControl?.currentPageIndicatorTintColor = .black
        pageControl?.numberOfPages = 2
        pageControl!.currentPage = 0
        pageControl!.isUserInteractionEnabled = false
        self.view.addSubview(pageControl!)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height - 40), collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellView")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(collectionView)

        
        hintLabel = UILabel(frame: CGRect(x: 0, y: -65, width: self.view.bounds.width, height: 100))
        hintLabel?.font = UIFont.systemFont(ofSize: 11.0)
        hintLabel?.text = "PULL UP FOR SETTINGS"
        hintLabel?.textAlignment = .center
        hintLabel?.alpha = 0.4
        hintLabel?.textColor = .white
        
        self.view.addSubview(hintLabel!)

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

        if (tableView == commandTableView){
            return Commands.count
        }else{
            return Extensions.count
        }
    }
    
     @objc func switchChanged(_ sender : UISwitch!){
        // insert active command code here
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if tableView == self.commandTableView {
            cell.textLabel?.text = Commands[indexPath.row].name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(false, animated: true)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            switchView.isOn = Commands[indexPath.row].active
            cell.accessoryView = switchView
            cell.selectionStyle = .none
            switchView.onTintColor = .black
        } else {
            cell.textLabel?.text = Extensions[indexPath.row].name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            cell.selectionStyle = .none
            
            let price = Extensions[indexPath.row].price
            
            let button = UIButton(frame: CGRect(x: cell.bounds.width - 22, y: (cell.bounds.height/2) - 15, width: 60, height: 30))
            button.setTitle(price == 0 ? "Get" : "$" + String(price), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.layer.cornerRadius = 15
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            cell.addSubview(button)
            
        }
        return cell
      }
}

extension SettingsController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.parent!.view.frame.width, height: self.parent!.view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offset = scrollView.contentOffset.x
         if (offset >= self.view.frame.width) {
            self.pageControl!.currentPage = 1
         } else {
            self.pageControl!.currentPage = 0
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellView", for: indexPath)

        let titleView = UILabel(frame: CGRect(x: 35, y: 0, width: cell.bounds.width - 35, height: 100))
        titleView.font = UIFont.boldSystemFont(ofSize: 32.0)

        if (indexPath.row == 0) {
            titleView.text = "Commands"
            
            commandTableView = UITableView(frame: CGRect(x: 21, y: 75, width: self.view.bounds.width - 40, height: UIScreen.main.bounds.height - 75))
            commandTableView!.isScrollEnabled = false
            commandTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            commandTableView?.rowHeight = 50
            commandTableView?.dataSource = self
            commandTableView?.separatorColor = .clear

            cell.addSubview(commandTableView!)
        } else {
            titleView.text = "Extensions"
            
            let extensionTableView = UITableView(frame: CGRect(x: 21, y: 125, width: self.view.bounds.width - 40, height: UIScreen.main.bounds.height - 75))
            extensionTableView.isScrollEnabled = false
            extensionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            extensionTableView.rowHeight = 50
            extensionTableView.dataSource = self
            extensionTableView.separatorColor = .clear
            
            let searchBar = TextField(frame: CGRect(x: 35, y: 80, width: self.view.bounds.width - 67, height: 40))
            searchBar.delegate = self
            searchBar.backgroundColor = .white
            searchBar.layer.borderColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 0.7).cgColor
            searchBar.layer.borderWidth = 1
            searchBar.layer.cornerRadius = 5
            searchBar.placeholder = "Search for an extension..."
            searchBar.font = UIFont.systemFont(ofSize: 15)
            cell.addSubview(searchBar)
            

            cell.addSubview(extensionTableView)
        }
        cell.addSubview(titleView)
        return cell
    }
}
