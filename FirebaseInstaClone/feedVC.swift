//
//  FirstViewController.swift
//  FirebaseInstaClone
//
//  Created by Atil Samancioglu on 6.10.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
        
    }
    
    func getDataFromFirebase() {
        
        let databaseReference = Database.database().reference()
        
        databaseReference.child("users").observe(DataEventType.childAdded) { (snapshot) in
            //print("children: \(snapshot.children)")
            //print("value: \(snapshot.value)")
            //print("key: \(snapshot.key)")

            
            let values = snapshot.value! as! NSDictionary
            
            let post = values["post"] as! NSDictionary
            
            let postID = post.allKeys
            
            for id in postID {
                let singlePost = post[id] as! NSDictionary
                
                self.userCommentArray.append(singlePost["posttext"] as! String)
                self.userEmailArray.append(singlePost["postedby"] as! String)
                self.userImageArray.append(singlePost["image"] as! String)

            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.userCommentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        
        return cell
    }


    @IBAction func logoutClicked(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! signInVC
        
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = signIn
        
        delegate.rememberUser()
        
        do {
            try Auth.auth().signOut()
        } catch  {
            print(error)
        }
    
    }
}

