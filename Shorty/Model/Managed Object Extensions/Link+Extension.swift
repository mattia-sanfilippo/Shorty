//
//  Link+Extension.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import Foundation
import CoreData

extension Link {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}
