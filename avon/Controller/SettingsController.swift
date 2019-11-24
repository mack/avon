//
//  SettingsController.swift
//  avon
//
//  Created by Mackenzie Boudreau & Jarret Terrio on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit

var Commands = [
    Command(name: "Call", active: false, fn: ()),
    Command(name: "Text", active: true, fn: nil),
    Command(name: "Reminder", active: false, fn: nil),
    Command(name: "Speed Warnings", active: false, fn: nil),
    Command(name: "Current Time", active: true, fn: nil),
]

class SettingsController: PullUpController {

    public var portraitSize: CGSize = .zero
    var tableView: UITableView?
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
        return Commands.count
      }
    
     @objc func switchChanged(_ sender : UISwitch!){
        // insert active command code here
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
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
    
        return cell
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
            
            tableView = UITableView(frame: CGRect(x: 21, y: 75, width: self.view.bounds.width - 40, height: UIScreen.main.bounds.height - 75))
            tableView!.isScrollEnabled = false
            tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView?.rowHeight = 50
            tableView?.dataSource = self
            tableView?.separatorColor = .clear

            cell.addSubview(tableView!)
        } else {
            titleView.text = "Extensions"
        }
        
        cell.addSubview(titleView)
        return cell
    }
}
