//
//  PlayerViewController.swift
//  YoutubeDemo
//
//  Created by Rikka Vivekanand Reddy on 10/5/17.
//  Copyright © 2017 Rikka Vivekanand Reddy. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    var playerView: UIView = UIView()
    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       // playerView.loadWithVideoId(videoID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
