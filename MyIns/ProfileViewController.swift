//
//  ProfileViewController.swift
//  MyIns
//
//  Created by Jingyuan Bi on 4/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var user:User!
    var posts:[Post] = []
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        //self.title = "Current User"
        loadUserInfo()
        loadPosts()

        // Do any additional setup after loading the view.
    }
    
    func loadUserInfo(){
        Helper.user.observeCurrentUser{(user) in
            self.ifFollowing(uid: user.uid!, completed: {
                (value) in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            })

        }
    }
    
    func ifFollowing(uid:String, completed: @escaping (Bool)->Void){
        Helper.follow.ifFollowing(userId: uid, completed: completed)
    }
    
    func loadPosts(){
        guard let currentUser = Helper.user.CURRENT_USER else{
            return
        }
        Helper.post.MY_POSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Helper.post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })

        })
        
//        Helper.post.loadPosts(userId: userId){
//            (key) in
//            Helper.post.observePost(withId: key, completion: {
//                post in
//                self.posts.append(post)
//                self.collectionView.reloadData()
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func LogoutBtnClicked(_ sender: Any) {
            do{
                try Auth.auth().signOut()
            } catch let error {
                print(error)
            }
            //print(Auth.auth().currentUser as Any)
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProfileViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as!
        HeaderCollectionReusableView
        //headerCell.updateInfo()
        if let user = self.user{
            headerCell.user = user
        }
        return headerCell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3-1, height: collectionView.frame.size.width/3-1)
    }
}
