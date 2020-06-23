	//
//  TableViewCellwithCollectionViewCell.swift
//  app2
//
//  Created by Jack Liu on 2020/6/22.
//  Copyright © 2020 Jack Liu. All rights reserved.
//

import UIKit
    class CollectionViewCell: UICollectionViewCell {
        
        
        @IBOutlet weak var CollectionViewImage: UIImageView!
        

        
    }
    let photolist=["142","addpic"]
    class TableViewCellwithCollectionViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photolist.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvcv", for: indexPath) as! CollectionViewCell
            cell.CollectionViewImage.image=UIImage(named: photolist[indexPath.row])
            return cell
        }
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
