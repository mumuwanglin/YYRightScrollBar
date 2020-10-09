//
//  ViewController.swift
//  YYRightScrollBar
//
//  Created by mumu on 2020/9/9.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tmp = UITableView(frame: .zero, style: .plain)
        tmp.dataSource = self
        tmp.delegate = self
        tmp.showsVerticalScrollIndicator = false
        tmp.showsHorizontalScrollIndicator = false
        tmp.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")        
        return tmp
    }()
    
    private lazy var scrollBar: YYScrollBar = {
        let tmp = YYScrollBar()
        tmp.delegate = self
        return tmp
    }()
    
    var dataSource = ["MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/","MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/", "MUMU", "MUMU", "MUMU", "MUMU", "https://mumuwanglin.github.io/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in            
            make.top.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(scrollBar)
        scrollBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.bottom.equalToSuperview().offset(-44)
            make.right.equalToSuperview()
            make.width.equalTo(26)
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

extension ViewController: YYScrollBarDelegate {
    func scrollBarDidScroll(scrollBar: YYScrollBar, rollingRatio: CGFloat) {
        let offsetY = (tableView.contentSize.height - tableView.frame.size.height) * rollingRatio
        tableView.contentOffset = CGPoint(x: 0, y: offsetY)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollBar.scrollViewDidScroll(scrollView)
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollBar.checkHideFastRollingBtn()
    }
}
