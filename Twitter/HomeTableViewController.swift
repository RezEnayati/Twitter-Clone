//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Reza Enayati on 2/25/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControll.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControll
    }
    
    let myRefreshControll = UIRefreshControl()
    
    
    @objc func loadTweets(){
        
        numberOfTweets = 100
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myPrams = ["count": numberOfTweets]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myPrams, success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControll.endRefreshing()
        }, failure: { Error in
            print("Could not retrieve tweets")
        })
    }
    


    func loadMoreTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myPrams  = ["counts": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myPrams, success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { Error in
            print("Could not retrieve tweets")
        })
    }
    override func tableView(_ tableView: UITableView,
                willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userloggedin")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}
