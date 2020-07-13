//
//  ViewController.swift
//  HJMap-Naver
//
//  Created by 김희중 on 2020/07/10.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit
import NMapsMap

class ViewController: UIViewController, NMFMapViewTouchDelegate {
    
    let locationButton = NMFLocationButton()
    let infoWindow = NMFInfoWindow()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nmapView = NMFNaverMapView(frame: view.frame)
        // true라고 설정을 해주어야만 작동을 한다.
        nmapView.showZoomControls = true
        nmapView.showLocationButton = true
        
        view.addSubview(nmapView)

        locationButton.frame = CGRect(x: 24, y: view.frame.height - 100, width: 50, height: 50)
        let camera = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.551664, lng: 126.925065), zoomTo: 15.0)
        nmapView.mapView.moveCamera(camera)
        nmapView.mapView.touchDelegate = self
        nmapView.mapView.positionMode = .direction
        
        
        setMarker(lat: 37.55174338811906, lng: 126.9257838320133, tag: "마커1", mapview: nmapView.mapView)
        setMarker(lat: 37.55199289289976, lng: 126.9232804368307, tag: "마커2", mapview: nmapView.mapView)
        
    }
    
    fileprivate func setMarker(lat: CLLocationDegrees, lng: CLLocationDegrees, tag: String, mapview: NMFMapView) {
        let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
        //        NMFMarker(position: <#T##NMGLatLng#>, iconImage: <#T##NMFOverlayImage#>)
        //        marker.iconTintColor = .red
        marker.userInfo = ["tag": tag]
        
        let handler: NMFOverlayTouchHandler = { [weak self] (overlay) -> Bool in
            if let marker = overlay as? NMFMarker {
                if marker.infoWindow == nil {
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    // 꼭 open하기전에 다시 datasource 지정해줄 것. 그리고 datasource 지정하고 그 다음에 open 해주어야 한다.
                    let dataSource = NMFInfoWindowDefaultTextSource.data()
//                    dataSource.title = "정보 창 내용"
                    dataSource.title = marker.userInfo["tag"] as! String
                    self?.infoWindow.dataSource = dataSource
                    self?.infoWindow.open(with: marker)
                }
                else {
                    self?.infoWindow.close()
                }
            }
            return true
        }

        marker.touchHandler = handler
        marker.mapView = mapview
    }

    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        // nmapFView.touchDelegate = self 해주어야 함.
        print("지도 탭 latlng: ",latlng )
        infoWindow.close()
    }

}

