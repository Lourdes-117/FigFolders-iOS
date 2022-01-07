//
//  Created by NBCUniversal on 3/10/21.
//  Copyright © 2021 NBCUniversal. All rights reserved.
//
import UIKit

extension NSLayoutConstraint {
    func getLayoutConstraintWithPriority(_ neededPriority: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        self.isActive = false
        constraint.priority = UILayoutPriority(rawValue: neededPriority)
        constraint.isActive = true
        return constraint
    }
}
