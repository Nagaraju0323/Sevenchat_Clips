
//
//  RTLCollectionFlow.swift
//  Sevenchats
//
//  Created by mac-00020 on 17/03/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import Foundation
import UIKit

class RTLCollectionFlow: UICollectionViewFlowLayout {
  override var flipsHorizontallyInOppositeLayoutDirection: Bool {
    return Localization.sharedInstance.applicationFlowWithLanguageRTL()
  }
}
