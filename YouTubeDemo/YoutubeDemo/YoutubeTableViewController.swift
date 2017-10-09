//
//  YoutubeTableViewController.swift
//  YoutubeDemo
//
//  Created by Rikka Vivekanand Reddy on 10/5/17.
//  Copyright © 2017 Rikka Vivekanand Reddy. All rights reserved.
//

import UIKit

class YoutubeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var tblVideos: UITableView = UITableView()
    var segDisplayedContent: UISegmentedControl!
    var viewWait: UIView = UIView()
    var txtSearch: UITextField = UITextField()
    
    //MARK: View lifecycle methods
    
    var apiKey = "AIzaSyCu6I2mwfw7Wqf2O7frv2yjokvevPdAX84"
    
    var desiredChannelsArray = ["Apple", "Google", "Microsoft"]
    
    var channelIndex = 0
    
    var channelsDataArray: [Dictionary<NSObject, AnyObject>] = []
    
    var videosArray:  [Dictionary<NSObject, AnyObject>] = []
    
    var selectedVideoIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblVideos.delegate = self
        tblVideos.dataSource = self
        txtSearch.delegate = self
        view.backgroundColor = UIColor.white
        setupView()
        let items = ["Channels", "Videos"]
        segDisplayedContent = UISegmentedControl(items: items)
        segDisplayedContent.selectedSegmentIndex = 0
        getChannelDetails(useChannelIDParam: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        view.addSubview(txtSearch)
        view.addSubview(tblVideos)
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
        tblVideos.translatesAutoresizingMaskIntoConstraints = false
        let txtTop = NSLayoutConstraint(item: txtSearch, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let txtLead = NSLayoutConstraint(item: txtSearch, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let txtTrail = NSLayoutConstraint(item: txtSearch, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let txtHeight = NSLayoutConstraint(item: txtSearch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        view.addConstraints([txtTop, txtLead, txtTrail, txtHeight])
        
        let tblTop = NSLayoutConstraint(item: tblVideos, attribute: .top, relatedBy: .equal, toItem: txtSearch, attribute: .bottom, multiplier: 1, constant: 0)
        let tblLead = NSLayoutConstraint(item: tblVideos, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let tblTrail = NSLayoutConstraint(item: tblVideos, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let tblHeight = NSLayoutConstraint(item: tblVideos, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -60)
        view.addConstraints([tblTop, tblLead, tblTrail, tblHeight])
        tblVideos.register(UITableViewCell.self, forCellReuseIdentifier: "idCellChannel")
    }
    
    func navigateToVideo() {
        let pvc: PlayerViewController = PlayerViewController()
        pvc.videoID = videosArray[selectedVideoIndex]["videoID" as NSObject] as! String
        self.navigationController?.pushViewController(pvc, animated: false)
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func changeContent(sender: AnyObject) {
        tblVideos.reloadSections([0], with: .fade)
    }
    
    
    // MARK: UITableView method implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segDisplayedContent.selectedSegmentIndex == 0 {
            return channelsDataArray.count
        }
        else {
            return videosArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if segDisplayedContent.selectedSegmentIndex == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "idCellChannel", for: indexPath)
            
            let channelTitleLabel = cell.viewWithTag(10) as? UILabel
            let channelDescriptionLabel = cell.viewWithTag(11) as? UILabel
            let thumbnailImageView = cell.viewWithTag(12) as? UIImageView
            
            let channelDetails = channelsDataArray[indexPath.row] as Dictionary
            var str = "title"
            channelTitleLabel?.text = channelDetails[str as NSObject] as! String
            channelDescriptionLabel?.text = channelDetails["description" as NSObject] as? String
            let str1 = channelDetails["thumbnail" as NSObject] as! String
            //thumbnailImageView.image = UIImage(data: NSData(contentsOf: NSURL(string: str1)! as URL) as Data)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
            
            let videoTitle = cell.viewWithTag(10) as! UILabel
            let videoThumbnail = cell.viewWithTag(11) as! UIImageView
            
            let videoDetails = videosArray[indexPath.row]
            let str = videoDetails["thumbnail" as NSObject] as! String
            videoTitle.text = videoDetails["title" as NSObject] as? String
            //videoThumbnail.image = UIImage(data: NSData(contentsOf: NSURL(string: str)! as URL) as Data)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segDisplayedContent.selectedSegmentIndex == 0 {
            // In this case the channels are the displayed content.
            // The videos of the selected channel should be fetched and displayed.
            
            // Switch the segmented control to "Videos".
            segDisplayedContent.selectedSegmentIndex = 1
            
            // Show the activity indicator.
            viewWait.isHidden = false
            
            // Remove all existing video details from the videosArray array.
            videosArray.removeAll(keepingCapacity: false)
            
            // Fetch the video details for the tapped channel.
            getVideosForChannelAtIndex(index: indexPath.row)
        }
        else {
            selectedVideoIndex = indexPath.row
            navigateToVideo()
        }
    }
    
    
    // MARK: UITextFieldDelegate method implementation
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewWait.isHidden = false
        
        // Specify the search type (channel, video).
        var type = "channel"
        if segDisplayedContent.selectedSegmentIndex == 1 {
            type = "video"
            videosArray.removeAll(keepingCapacity: false)
        }
        
        // Form the request URL string.
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(String(describing: textField.text))&type=\(type)&key=\(apiKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // Create a NSURL object based on the above string.
        let targetURL = URL(string: urlString)
        
        // Get the results.
        performGetRequest(targetURL: targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                // Convert the JSON data to a dictionary object.
                do {
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items" as NSObject] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Loop through all search results and keep just the necessary data.
                    for item in items {
                        let snippetDict = item["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                        
                        // Gather the proper data depending on whether we're searching for channels or for videos.
                        if self.segDisplayedContent.selectedSegmentIndex == 0 {
                            // Keep the channel ID.
                            self.desiredChannelsArray.append(snippetDict["channelId" as NSObject] as! String)
                        }
                        else {
                            // Create a new dictionary to store the video details.
                            var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                            videoDetailsDict["title" as NSObject] = snippetDict["title" as NSObject]
                            videoDetailsDict["thumbnail" as NSObject] = ((snippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                            videoDetailsDict["videoID" as NSObject] = (item["id" as NSObject] as! Dictionary<NSObject, AnyObject>)["videoId" as NSObject]
                            
                            // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                            self.videosArray.append(videoDetailsDict)
                            
                            // Reload the tableview.
                            self.tblVideos.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
                
                // Call the getChannelDetails(…) function to fetch the channels.
                if self.segDisplayedContent.selectedSegmentIndex == 0 {
                    self.getChannelDetails(useChannelIDParam: true)
                }
                
            }
            else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
            
            // Hide the activity indicator.
            self.viewWait.isHidden = true
        })
        
        
        return true
    }
    
    
    // MARK: Custom method implementation
    
    func performGetRequest(targetURL: URL!, completion: @escaping (_ data: Data?, _ HTTPStatusCode: Int, _ error: Error?) -> Void) {
        let request = NSMutableURLRequest(url: targetURL as URL)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async { () -> Void in
                completion(data , (response as! HTTPURLResponse).statusCode, error)
                
            }
        })
        
        task.resume()
    }
    
    
    func getChannelDetails(useChannelIDParam: Bool) {
        var urlString: String!
        if !useChannelIDParam {
            urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=\(desiredChannelsArray[channelIndex])&key=\(apiKey)"
        }
        else {
            urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(desiredChannelsArray[channelIndex])&key=\(apiKey)"
        }
        
        let targetURL = URL(string: urlString)
        
        performGetRequest(targetURL: targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get the first dictionary item from the returned items (usually there's just one item).
                    let items: AnyObject! = resultsDict["items" as NSObject] as AnyObject!
                    let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                    
                    // Get the snippet dictionary that contains the desired data.
                    let snippetDict = firstItemDict["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                    
                    // Create a new dictionary to store only the values we care about.
                    var desiredValuesDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                    desiredValuesDict["title" as NSObject] = snippetDict["title" as NSObject]
                    desiredValuesDict["description" as NSObject] = snippetDict["description" as NSObject]
                    desiredValuesDict["thumbnail" as NSObject] = ((snippetDict["thumbnails" as NSObject]  as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                    
                    // Save the channel's uploaded videos playlist ID.
                    desiredValuesDict["playlistID" as NSObject] = ((firstItemDict["contentDetails" as NSObject] as! Dictionary<NSObject, AnyObject>)["relatedPlaylists" as NSObject] as! Dictionary<NSObject, AnyObject>)["uploads" as NSObject]
                    
                    
                    // Append the desiredValuesDict dictionary to the following array.
                    self.channelsDataArray.append(desiredValuesDict)
                    
                    
                    // Reload the tableview.
                    self.tblVideos.reloadData()
                    
                    // Load the next channel data (if exist).
                    self.channelIndex = self.channelIndex + 1
                    if self.channelIndex < self.desiredChannelsArray.count {
                        self.getChannelDetails(useChannelIDParam: useChannelIDParam)
                    }
                    else {
                        self.viewWait.isHidden = true
                    }
                } catch {
                    print(error)
                }
                
            } else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })
    }
    
    
    func getVideosForChannelAtIndex(index: Int!) {
        // Get the selected channel's playlistID value from the channelsDataArray array and use it for fetching the proper video playlst.
        let playlistID = channelsDataArray[index]["playlistID" as NSObject] as! String
        
        // Form the request URL string.
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID)&key=\(apiKey)"
        
        // Create a NSURL object based on the above string.
        let targetURL = URL(string: urlString)
        
        // Fetch the playlist from Google.
        performGetRequest(targetURL: targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    // Convert the JSON data into a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items" as NSObject] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Use a loop to go through all video items.
                    for item in items {
                        let playlistSnippetDict = (item as Dictionary<NSObject, AnyObject>)["snippet" as NSObject] as! Dictionary<NSObject, AnyObject>
                        
                        // Initialize a new dictionary and store the data of interest.
                        var desiredPlaylistItemDataDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistItemDataDict["title" as NSObject] = playlistSnippetDict["title" as NSObject]
                        desiredPlaylistItemDataDict["thumbnail" as NSObject] = ((playlistSnippetDict["thumbnails" as NSObject] as! Dictionary<NSObject, AnyObject>)["default" as NSObject] as! Dictionary<NSObject, AnyObject>)["url" as NSObject]
                        desiredPlaylistItemDataDict["videoID" as NSObject] = (playlistSnippetDict["resourceId" as NSObject] as! Dictionary<NSObject, AnyObject>)["videoId" as NSObject]
                        
                        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                        self.videosArray.append(desiredPlaylistItemDataDict)
                        
                        // Reload the tableview.
                        self.tblVideos.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
            
            // Hide the activity indicator.
            self.viewWait.isHidden = true
        })
    }
}
