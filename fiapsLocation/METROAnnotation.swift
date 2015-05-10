//
//  FIAPAnnotation.swift
//  fiapsLocation
//
//  Created by Kaue Mendes on 4/23/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import MapKit

class METROAnnotation: NSObject, MKAnnotation {
    
    @objc var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
