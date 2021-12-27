//
//  ExtensionUITableView.swift
//  EasyExchange
//
//  Created by Mac-00014 on 26/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

extension UITableView {

    var pullToRefreshControl: UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return self.refreshControl
            } else {
                return self.viewWithTag(9876) as? UIRefreshControl
            }
        } set {
            if #available(iOS 10.0, *) {
                self.refreshControl = newValue
            } else {
                if let refreshControl = newValue {
                    refreshControl.tag = 9876
                    self.addSubview(refreshControl)
                }
            }
        }
    }
    
    func lastIndexPath() -> IndexPath?
    {
        let sections = self.numberOfSections
        
        if (sections<=0){
            return nil
        }
        
        let rows = self.numberOfRows(inSection: sections-1)
        
        if (rows<=0){return nil}
        
        return IndexPath(row: rows-1, section: sections-1)
    }
    
    func tableViewDummyCell() -> UITableViewCell {
        let defaultCell = UITableViewCell(frame: .zero)
        defaultCell.selectionStyle = .none
        return defaultCell
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            
            guard 0 < self.numberOfSections && 0 < self.numberOfRows(inSection: 0) else {
//                    setTableStatus(type: .empty)
                    return
                }
            
            if self.numberOfRows(inSection: 0) > 1 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func setEmptyMessage(_ message: String) {
        
        let view = UIView()
        self.backgroundView = view;
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = CFontPoppins(size: 15, type: .regular)
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        //self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
    }
   
    func performUpdate(_ update: ()->Void, completion: (()->Void)?) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                update()
            }) { (isCompleted) in
                if !isCompleted { return }
                if let blk = completion { blk() }
            }
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            
            beginUpdates()
            update()
            endUpdates()
            
            CATransaction.commit()
        }
    }
    
    func updateHeaderViewHeight(extxtraSpace:CGFloat = 0) {
        DispatchQueue.main.async {
            if let headerView = self.tableHeaderView {
                headerView.setNeedsLayout()
                headerView.layoutIfNeeded()
                headerView.sizeToFit()
                let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                var headerFrame = headerView.frame
                
                //Comparison necessary to avoid infinite loop
                if height != headerFrame.size.height {
                    headerFrame.size.height = height + extxtraSpace
                    headerView.frame = headerFrame
                    self.tableHeaderView = headerView
                    self.layoutIfNeeded()
                }
            }
        }
    }
}
