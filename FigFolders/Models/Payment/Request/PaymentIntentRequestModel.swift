//
//  PaymentIntentRequestModel.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 28/07/23.
//

import Foundation

struct PaymentIntentRequestModel: Codable {
  var amount: String
  var currency: String?
  var description: String?
  var source: String?
}
