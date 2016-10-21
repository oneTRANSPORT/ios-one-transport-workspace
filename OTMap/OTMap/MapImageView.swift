//
//  MapImageView.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 08/09/2016.
//  Copyright 2016 InterDigital Communications, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import MapKit

class MapImageView: UIImageView {

    var mapView : MapView? = MapView()
    
    func generateImage(_ from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
        let filename = String(format:"%@/MapForVector:%.5f:%.5f:%.5f:%.5f.png", FileManager.cachesDir(), from.latitude, from.longitude, to.latitude, to.longitude)
        if !FileManager.default.fileExists(atPath: filename) {
            self.mapView = MapView.init(frame: self.frame)
        
            let dataSource = MapDataSource.init()
            self.mapView!.dataSource = dataSource
        
            mapView!.setRegion(self.regionForPoints(from, to: to), animated: false)
        
            let options = MKMapSnapshotOptions()
            options.scale = UIScreen.main.scale
            options.region = mapView!.region
            options.size = mapView!.bounds.size
            options.mapType = .standard

            let camera = MKMapSnapshotter.init(options: options)
            camera.start(completionHandler: { (photo, error) in
                if error == nil {
                    let image = self.imageByDrawingOnImage(photo!.image)
                    let data = UIImagePNGRepresentation(image)
                    try? data!.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                    
                    self.image = image
                }
                self.mapView = nil
            })
        } else {
            self.image = UIImage.init(contentsOfFile: filename)!
        }
    }
    
    func regionForPoints(_ from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) ->MKCoordinateRegion {
        
        var latMin : Double = 999
        var latMax : Double = -999;
        var lonMin : Double = 999
        var lonMax : Double = -999;
        
        if from.latitude  < latMin {
            latMin = from.latitude
        }
        if from.latitude > latMax {
            latMax = from.latitude
        }
        if from.longitude  < lonMin {
            lonMin = from.longitude
        }
        if from.longitude > lonMax {
            lonMax = from.longitude
        }
        
        if to.latitude  < latMin {
            latMin = to.latitude
        }
        if to.latitude > latMax {
            latMax = to.latitude
        }
        if to.longitude  < lonMin {
            lonMin = to.longitude
        }
        if to.longitude > lonMax {
            lonMax = to.longitude
        }
        
        let center = CLLocationCoordinate2DMake((latMin + latMax) / 2.0, (lonMin + lonMax) / 2.0)
        var span = MKCoordinateSpanMake(latMax - latMin, lonMax - lonMin)
        if span.latitudeDelta == 0 && span.longitudeDelta == 0 {        //single point, so generate a small span
            span = MKCoordinateSpanMake(0.001, 0.001)
        }
        let region = MKCoordinateRegionMake (center, span)
        return region
    }
        
    func imageByDrawingOnImage(_ image : UIImage) ->UIImage {
        
        return image
    }
}

extension FileManager {
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
