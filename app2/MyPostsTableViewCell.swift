//
//  MyPostsTableViewCell.swift
//  app2
//
//  Created by Jack Liu on 2020/6/23.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var PoststextView: UITextView!
    @IBOutlet weak var TimeLabel0: UILabel!
    @IBOutlet weak var selfieImage0: UIButton!
    
    @IBOutlet weak var userNameLabel1: UILabel!
    @IBOutlet weak var PoststextView1: UITextView!
    @IBOutlet weak var PostImage1: UIImageView!
    @IBOutlet weak var TimeLabel1: UILabel!
    @IBOutlet weak var selfieImage1: UIButton!
    
    @IBOutlet weak var userNameLabel2: UILabel!
    @IBOutlet weak var PoststextView2: UITextView!
    @IBOutlet weak var PostImage2a: UIImageView!
    @IBOutlet weak var PostImage2b: UIImageView!
    @IBOutlet weak var TimeLabel2: UILabel!
    @IBOutlet weak var selfieImage2: UIButton!
    @IBOutlet weak var testimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
