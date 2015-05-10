//
//  POIAnnotation.swift
//  fiapsLocation
//
//  Created by Kaue Mendes on 4/23/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import MapKit

class POIAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var mapItem: MKMapItem
    var imageName = UIImage(named: "poi")
    
    init(coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String,
        mapItem: MKMapItem) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.mapItem = mapItem
        }
    
}