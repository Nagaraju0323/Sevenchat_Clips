//
//  FilterSubCatTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
let kItemPadding = 15

protocol FilterDelegate {
    func didSelectFilterCategory(_ category : Any?, isSelected : Bool?, section : Int?)
    
}

class FilterSubCatTblCell: UITableViewCell,MICollectionViewBubbleLayoutDelegate {
    
    
    var delegate : FilterDelegate!
    @IBOutlet var clBubble : UICollectionView!
    @IBOutlet var cnClBubbleHieght : NSLayoutConstraint!
    
    var arrSubCategroy = [[String : Any]]()
    var arrSelectedCategroy = [[String : Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //...UICollectionView setup
        let bubbleLayout = MICollectionViewBubbleLayout()
        bubbleLayout.minimumLineSpacing = 10.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        self.clBubble.setCollectionViewLayout(bubbleLayout, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            clBubble.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            clBubble.transform = CGAffineTransform.identity
        }
    }
}
// MARK:- --------- Sub Category
extension FilterSubCatTblCell{
    
    func showSubCategory(_ arrCat : [[String : Any]]?,_ arrSelected : [[String : Any]]?)
    {
        arrSubCategroy = arrCat!
        arrSelectedCategroy = arrSelected!
        
        self.cnClBubbleHieght.constant = 0.0
        self.clBubble.reloadData()
        
        if self.arrSubCategroy.count > 0 {
            self.calculateCollectionViewHeight()
        }
        
    }
    
    // Calculate dynamic height with bubble view layout
    func calculateCollectionViewHeight() {
        
        var x : CGFloat = 0.0
        var y : CGFloat = 0.0
        var iSize : CGSize = CGSize.zero
        
        for catInfo in arrSubCategroy {
            let catName = catInfo.valueForString(key: CName)
            let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
            
            iSize = catName.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
            iSize.width = CGFloat(ceilf(Float(iSize.width + CGFloat(kItemPadding * 2))))

            iSize.width += 12
            iSize.height = 25
            
            // If width is greater then collection view frame..
            if iSize.width > clBubble.frame.size.width {
                iSize.width = clBubble.frame.size.width
            }
            
            var itemRect : CGRect = CGRect(x: x, y: y, width: iSize.width, height: iSize.height)
            
            if (x > 0 && x + iSize.width + 6 > (CScreenWidth - 28))
            {
                itemRect.origin.x = 0.0
                itemRect.origin.y = y + iSize.height + 6
            }
            
            x = itemRect.origin.x + iSize.width + 6;
            y = itemRect.origin.y;
        }
        
        y += iSize.height + CGFloat(kItemPadding * 2)
        x = 0.0
        
        self.cnClBubbleHieght.constant = y
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension FilterSubCatTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubCategroy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleCollCell", for: indexPath) as! BubbleCollCell
        
        let cateInfo = arrSubCategroy[indexPath.row]
        cell.lblCategory.text = cateInfo.valueForString(key: CName)
        
        if arrSelectedCategroy.contains(where: {$0.valueForInt(key: CId) == cateInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == cateInfo.valueForString(key: CType)}){
            cell.backgroundColor = CRGB(r: 139, g: 180, b: 131)
            cell.lblCategory.textColor = UIColor.white
        }else{
            cell.backgroundColor = CRGB(r: 228, g: 253, b: 225 )
            cell.lblCategory.textColor = UIColor.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var section = 0
        if let tblView = self.superview as? UITableView {
            section = (tblView.indexPath(for: self)?.section)!
        }
        
      
        let cateInfo = arrSubCategroy[indexPath.row]
        if arrSelectedCategroy.contains(where: {$0.valueForInt(key: CId) == cateInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == cateInfo.valueForString(key: CType)}) {
            
            if let index = arrSelectedCategroy.index(where: {$0.valueForInt(key: CId) == cateInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == cateInfo.valueForString(key: CType)}) {
                arrSelectedCategroy.remove(at: index)
                delegate.didSelectFilterCategory(cateInfo, isSelected: false, section : section)
            }
            
        }else {
            arrSelectedCategroy.append(cateInfo)
            delegate.didSelectFilterCategory(cateInfo, isSelected: true, section : section)
        }
        
        clBubble.reloadData()
    }
    
    // MARK: -
    // MARK: - MICollectionViewBubbleLayoutDelegate
    
    func collectionView(_ collectionView:UICollectionView, itemSizeAt indexPath:NSIndexPath) -> CGSize {
        
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        let catInfo = arrSubCategroy[indexPath.row]
        let title = catInfo.valueForString(key: CName)
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + CGFloat(kItemPadding * 2))))
        size.height = 25
        
        //...Checking if item width is greater than collection view width then set item width == collection view width.
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        
        return size;
    }
    
}
