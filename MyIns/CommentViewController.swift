//
//  CommentViewController.swift
//  MyIns
//
//  Created by Jingyuan Bi on 2/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth

class CommentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postID: String!
    var comments = [Comment]()
    var users = [User]()
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var postCommentBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchComments()
        commentText.addTarget(self, action: #selector(self.handleCommentText), for: UIControlEvents.editingChanged)
        handleCommentText()
        clean()
        handleTextSize()
    }
    

    func handleTextSize(){
        commentText.placeholder = "comment here"
        commentText.adjustsFontSizeToFitWidth  = true
        commentText.minimumFontSize=10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //load comments
    func fetchComments(){
        API.postComments.fetchPostComments(withPostID: postID!) { (pcsnapshot) in
            API.comment.fetchComment(withCommentID: pcsnapshot, Competion: { (comment) in
                API.user.fetchUser(uid: comment.uid!, completion: { (user) in
                    self.users.append(user)
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        }
    }
////load comments
//    func fetchComments(){
//        Database.database().reference().child("postComments").child(postID!).observe(.childAdded) { (pcsnapshot) in
//            Database.database().reference().child("comments").child(pcsnapshot.key).observeSingleEvent(of: .value, with: { (commentSnapshot) in
//                if let dict = commentSnapshot.value as? [String: Any]{
//                    let comment = Comment.transformComment(dict: dict)
//                    self.fetchUsers(uid: comment.uid!, completion: { (user) in
//                        self.users.append(user)
//                        self.comments.append(comment)
//                        self.tableView.reloadData()
//                    })
//
//                }
//            })
//            }
//        }

//    //load users
//    func fetchUsers(uid: String,completion : @escaping(User) -> Void){
//        _ = Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: Any]{
//                let user = User.transformUser(dict: dict, uid: uid)
//                print(user.email!)
//                completion(user)
//            }
//        })
//    }
    
    @objc func handleCommentText(){
        if (self.commentText.text?.isEmpty)! {
            postCommentBtn.isEnabled = false
            postCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        }else{
            postCommentBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
            postCommentBtn.isEnabled = true
        }
    }
    
    @IBAction func postCommentBtnClicked(_ sender: Any) {
        API.postComments.postNewComment(postID: self.postID, commentText: commentText.text!)
        clean()
        handleCommentText()
        view.endEditing(true)
//        let commentsRef = Database.database().reference().child("comments")
//        let commentID = commentsRef.childByAutoId().key
//        let newCommentRef = commentsRef.child(commentID!)
//        guard let currentUser = Auth.auth().currentUser else { return  }
//        let currentUserID = currentUser.uid
//        let now = Config.getCurrentTimeStamp()
//        newCommentRef.setValue(["uid": currentUserID,"commentText": commentText.text!, "timestamp":now ]) { (error, newCommentRef) in
//            if error != nil {
//                ProgressHUD.showError(error as! String)
//                return
//            }
//            let postCommentsRef = Database.database().reference().child("postComments").child(self.postID).child(commentID!)
//            postCommentsRef.setValue(true, withCompletionBlock: { (error, ref) in
//                if error != nil {
//                    ProgressHUD.showError(error as! String)
//                    return
//                }
//            })
//        }
//        clean()
//        handleCommentText()
//        view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func clean(){
        self.commentText.text = ""
        self.postCommentBtn.isEnabled = false
        postCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        cell.user = users[indexPath.row]
        return cell
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
