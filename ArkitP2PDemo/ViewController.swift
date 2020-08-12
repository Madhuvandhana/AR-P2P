//
//  ViewController.swift
//  ArkitP2PDemo
//
//  Created by Madhu Vijay on 8/10/20.
//

import UIKit
import ARCL
import CoreLocation
var sceneLocationView = SceneLocationView()
var iBeacon: CLBeacon?
var zevBeacon: CLBeacon?
class ViewController: UIViewController {

    let locationManager = CLLocationManager()

    let picImage:UIImageView = {
       let imageView = UIImageView()
       let image = UIImage(named: "pin")
       imageView.image = image
       imageView.contentMode = .scaleAspectFill
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
       }()
    override func viewDidLoad() {
      super.viewDidLoad()
      sceneLocationView.run()
      locationManager.requestAlwaysAuthorization()
       locationManager.delegate = self
        let uid =  UUID(uuidString: "A77B94E5-F974-4B6D-B0DD-E3064FCCAA44")!;
        let majorValue = CLBeaconMajorValue(0)
        let minorValue = CLBeaconMinorValue(0)
        startMonitoringItem(uuid: uid, majorValue: majorValue, minorValue: minorValue, name: "Madhu")
        let zevuid =  UUID(uuidString: "B77B94E5-F974-4B6D-B0DD-E3064FCCAA44")!;
        let zevmajorValue = CLBeaconMajorValue(0)
        let zevminorValue = CLBeaconMinorValue(0)
        startMonitoringItem(uuid: zevuid, majorValue: zevmajorValue, minorValue: zevminorValue, name: "Zev")
      view.addSubview(sceneLocationView)

    }
    func asBeaconRegion(uuid:UUID,majorValue:CLBeaconMajorValue,minorValue:CLBeaconMinorValue, name:String ) -> CLBeaconRegion {
      return CLBeaconRegion(proximityUUID: uuid,
                                    major: majorValue,
                                    minor: minorValue,
                               identifier: name)
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

    sceneLocationView.frame = view.bounds

    }
    func startMonitoringItem(uuid:UUID,majorValue:CLBeaconMajorValue,minorValue:CLBeaconMinorValue, name:String) {
        let beaconRegion = asBeaconRegion(uuid: uuid, majorValue: majorValue, minorValue: minorValue, name: name)
      locationManager.startMonitoring(for: beaconRegion)
      locationManager.startRangingBeacons(in: beaconRegion)
    }
    func stopMonitoringItem(uuid:UUID,majorValue:CLBeaconMajorValue,minorValue:CLBeaconMinorValue, name:String) {
        let beaconRegion = asBeaconRegion(uuid: uuid, majorValue: majorValue, minorValue: minorValue, name: name)
      locationManager.stopMonitoring(for: beaconRegion)
      locationManager.stopRangingBeacons(in: beaconRegion)
    }
    func locationString() -> String {
      guard let beacon = iBeacon else { return "Location: Unknown" }
      let proximity = nameForProximity(beacon.proximity)
      let accuracy = String(format: "%.2f", beacon.accuracy)
        
      var location = "Location: \(proximity)"
      if beacon.proximity != .unknown {
        location += " (approx. \(accuracy)m)"
      }
        
      return location
    }
    func zevlocationString() -> String {
      guard let beacon = zevBeacon else { return "Location: Unknown" }
      let proximity = nameForProximity(beacon.proximity)
      let accuracy = String(format: "%.2f", beacon.accuracy)
        
      var location = "Location: \(proximity)"
      if beacon.proximity != .unknown {
        location += " (approx. \(accuracy)m)"
      }
        
      return location
    }
    func nameForProximity(_ proximity: CLProximity) -> String {
      switch proximity {
      case .unknown:
        return "Unknown"
      case .immediate:
        return "Immediate"
      case .near:
        return "Near"
      case .far:
        return "Far"
      }
    }


}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      print("Failed monitoring region: \(error.localizedDescription)")
    }
      
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let currentLoc = manager.location
        print("lat:",currentLoc?.coordinate.latitude)
        print("long:",currentLoc?.coordinate.longitude)
      // Find the same beacons in the table.
        let maduid =  UUID(uuidString: "A77B94E5-F974-4B6D-B0DD-E3064FCCAA44")!;
        let zevuid =  UUID(uuidString: "B77B94E5-F974-4B6D-B0DD-E3064FCCAA44")!;
      for beacon in beacons {
        print(beacon.proximityUUID.uuidString)
        if (beacon.proximityUUID.uuidString == maduid.uuidString  ){
                print("beacon match found")
                iBeacon = beacon
            }
        else if(beacon.proximityUUID.uuidString == zevuid.uuidString ){
            zevBeacon = beacon
        }
      }
        let lat = currentLoc?.coordinate.latitude ??  71.504571;
        let lon = currentLoc?.coordinate.longitude ??  -0.019717;
        let iconsSize = CGRect(x: 0, y: -5, width: 160, height: 150)
        let image = UIImage(named: "madhu")
        let attributedString = NSMutableAttributedString(string: "")

        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: attachment))
        attributedString.append(NSAttributedString(string: "\nMadhu\n"+locationString()))
        let coordinate = CLLocationCoordinate2D(latitude: 71.504571, longitude:  -0.019717)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 220))
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        label.attributedText = attributedString
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3;
        let annotationNode = LocationAnnotationNode(location: location, view: label)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        let image1 = UIImage(named: "zev")
        let attributedString1 = NSMutableAttributedString(string: "")
        let attachment1 = NSTextAttachment()
        attachment1.image = image1
        attachment1.bounds = iconsSize
        attributedString1.append(NSAttributedString(attachment: attachment1))
        attributedString1.append(NSAttributedString(string: "\nZev\n"+zevlocationString()))
        let coordinate1 = CLLocationCoordinate2D(latitude: 30.75, longitude:  -0.019717)
        let location1 = CLLocation(coordinate: coordinate1, altitude: 300)
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 220))
        label1.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        label1.attributedText = attributedString1
        label1.backgroundColor = .white
        label1.textAlignment = .center
        label1.numberOfLines = 3;
        let annotationNode1 = LocationAnnotationNode(location: location1, view: label1)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
      // Update beacon locations of visible rows.
    }
}

