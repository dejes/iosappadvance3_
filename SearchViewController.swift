//
//  SearchViewController.swift
//  app2
//
//  Created by Jack Liu on 2020/6/25.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {
    var tableView: UITableView!
    var searchController: UISearchController!
    var dataList = [String]() // 預設呈現在畫面上的資料集合
    var filterDataList: [String] = [String]() // 搜尋結果集合
    var uniwriter = [String] ()
    //var userPost=[sheetDB_GETdata]() // 被搜尋的資料集合
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return
        }
        
        self.filterDataSource()
    }
    
    // 過濾被搜陣列裡的資料
    func filterDataSource() {
        // 使用高階函數來過濾掉陣列裡的資料
        self.filterDataList = uniwriter.filter({ (fruit) -> Bool in
            return fruit.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
        })
        
        if self.filterDataList.count > 0 {
            self.isShowSearchResult = true
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
        } else {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            // ...
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            return self.filterDataList.count
        } else {
            return dataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            cell!.textLabel?.text = String(filterDataList[indexPath.row])
        } else {
            cell!.textLabel?.text = String(dataList[indexPath.row])
        }
        
        return cell!
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需實作，因有遵守UISearchResultsUpdating協議的話，則輸入文字的當下即會觸發updateSearchResults，所以等同於同一件事做了兩次(可依個人需求決定，也不一定要跟法蘭克一樣選擇不實作)
    }
    
    // 點擊searchBar上的取消按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 依個人需求決定如何實作
        // ...
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發updateSearchResults的delegate做查詢的動作(可依個人需求決定如何實作)
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.placeholder = "Search user in last page"
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self // 設定代理UISearchResultsUpdating的協議
        self.searchController.searchBar.delegate = self // 設定代理UISearchBarDelegate的協議
        self.searchController.dimsBackgroundDuringPresentation = false // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        
        // 將searchBar掛載到tableView上
        self.tableView.tableHeaderView = self.searchController.searchBar
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
