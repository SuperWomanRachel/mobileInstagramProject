//
//  DiscoverViewController.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchbar  = UISearchBar()
    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        //set the search bar
        searchbar.searchBarStyle = .minimal
        searchbar.placeholder = "Search"
        searchbar.frame.size.width = view.frame.size.width-60
        
        let searchItem = UIBarButtonItem(customView: searchbar)
        self.navigationItem.rightBarButtonItem = searchItem
        search()

        // Do any additional setup after loading the view.
    }
    
    func search(){
        if let searchText = searchbar.text?.lowercased(){
            //avoid appending search results to the table
            self.users.removeAll()
            self.tableView.reloadData()
            Helper.user.searchUsers(withText: searchText, completion: {
                (user) in
                self.ifFollowing(uid: user.uid!, completed: {
                    value in
                    print(user.uid)
                    user.isFollowing = value
                    //print(value)
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func ifFollowing(uid:String, completed: @escaping (Bool)->Void){
        Helper.follow.ifFollowing(userId: uid, completed: completed)
    }

}

extension DiscoverViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        search()
    }
}

extension DiscoverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverUserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}
