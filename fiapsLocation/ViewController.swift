//
//  ViewController.swift
//  fiapsLocation
//
//  Created by Kaue Mendes on 4/23/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var optTypeMap: UISegmentedControl!
    var myLocations: [CLLocation] = []
    var manager:CLLocationManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()
        
        //Setup our Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
        mapView.zoomEnabled = true
        
        
        let fiapLocation:CLLocationCoordinate2D  = CLLocationCoordinate2DMake(-23.573978,-46.623272)
        let fiapAnnotation : MKAnnotation = FIAPAnnotation(coordinate: fiapLocation, title: "FIAP", subtitle: "http://fiap.com.br")
        
        let metroLocation:CLLocationCoordinate2D  = CLLocationCoordinate2DMake(-23.589541,-46.634701)
        let metroAnnotation: MKAnnotation = METROAnnotation(coordinate: metroLocation, title: "Metrô Vila Mariana", subtitle: "Estação da linha azul")
   
        self.mapView.region = MKCoordinateRegionMakeWithDistance(fiapLocation, 500, 500)
        
        //criar um pin do parque do ibirapuera
        let ibiraAnnotation:MKPointAnnotation = MKPointAnnotation()
        ibiraAnnotation.coordinate = CLLocationCoordinate2DMake(-23.587416, -46.657634)
        ibiraAnnotation.title = "Parque do Ibirapuera"
        
        self.mapView.addAnnotations([ibiraAnnotation, fiapAnnotation, metroAnnotation])
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!){
        
        if view.annotation is FIAPAnnotation
        {
            
            let url:NSURL = NSURL(string: "http://www.fiap.com.br")!
            UIApplication.sharedApplication().openURL(url)
    
        }
        else if view.annotation is METROAnnotation
        {
            
            let url:NSURL = NSURL(string: "http://www.metro.sp.gov.br/")!
            UIApplication.sharedApplication().openURL(url)
            
        }
        else if view.annotation is POIAnnotation
        {
            
            self.displayRegionCenteredOnMapItem((view.annotation as! POIAnnotation).mapItem)
        }
            
            
            
    }
    
    func displayRegionCenteredOnMapItem (from:MKMapItem){
        
        //Obtem a localizacao do item passado como parametro
        let fromLocation: CLLocation = from.placemark.location;
        
        let region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
        
        
        let span = NSValue(MKCoordinateSpan:self.mapView.region.span)
        let opts = [
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan:region.span),
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: region.center)
        ]
        from.openInMapsWithLaunchOptions(opts)
    }
    
    func clearAnnotations()
    {
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        self.mapView.removeAnnotations( annotationsToRemove )
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        //inicia um request com o texto digitado  with the text typed on the search bar and with current map region
        
        println(searchBar.text.lowercaseString)
        
        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text.lowercaseString
        request.region = self.mapView.region
        
        //instancia uma busca em mapa com o request criado
        var search:MKLocalSearch = MKLocalSearch(request: request)
        
        //inicia um activity indicator
        var loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loading.center = self.view.center
        self.view.addSubview(loading)
        loading.startAnimating()
       
        //inicia a busca
        search.startWithCompletionHandler {
            (response:MKLocalSearchResponse!, error:NSError!) in
            if error==nil {
                
                //cria um array para guardar os resultados retornados
                var placemarks = NSMutableArray()
                for item:MKMapItem in response.mapItems as! [MKMapItem] {
                    
                    //cria uma nova marcação por resultado
                    let place = POIAnnotation(coordinate: item.placemark.coordinate, title: item.name, subtitle: "", mapItem: item)
                    
                    placemarks.addObject(place)
                }
                
                //limpa as annotations no mapa antes de adicionar as novas
                self.clearAnnotations()
                self.mapView.addAnnotations(placemarks as [AnyObject])
                
            }
            loading.stopAnimating()
            searchBar.resignFirstResponder()
            
        }
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        if annotation is FIAPAnnotation{
    
            //verificar se a marcação já existe para tentar reutilizá-la
            let reuseId = "fiapAnnot"
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            //se a view não existir
            if anView == nil {
                //criar a view como subclasse de MKAnnotationView
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                //trocar a imagem pelo logo da FIAP
                anView.image = UIImage(named:"fiapLogo")
                
                //permitir que mostre o "balão" com informações da marcação
                anView.canShowCallout = true
                
                //adiciona um botão do lado direito do balão para futuro 'tap'
                anView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
            
            return anView
        } else if annotation is METROAnnotation {
            //verificar se a marcação já existe para tentar reutilizá-la
            let reuseId = "fiapAnnot"
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            //se a view não existir
            if anView == nil {
                //criar a view como subclasse de MKAnnotationView
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                //trocar a imagem pelo logo da FIAP
                anView.image = UIImage(named:"metroIco")
                
                //permitir que mostre o "balão" com informações da marcação
                anView.canShowCallout = true
                
                //adiciona um botão do lado direito do balão para futuro 'tap'
                anView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
            return anView
        } else if annotation is POIAnnotation{
            
            //verificar se a marcação já existe para tentar reutilizá-la
            let reuseId = "poiAnnot"
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            //se a view não existir
            if anView == nil {
                //criar a view como subclasse de MKAnnotationView
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                anView.image = (annotation as! POIAnnotation).imageName
                
                //permitir que mostre o "balão" com informações da marcação
                anView.canShowCallout = true
                
                //adiciona um botão do lado direito do balão para futuro 'tap'
                anView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }
            return anView
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func mapChangeView(sender: UISegmentedControl) {
        
        
        switch(optTypeMap.selectedSegmentIndex){
            case 1:
                mapView.mapType = MKMapType.Satellite
            
            case 2:
                mapView.mapType = MKMapType.Hybrid
            
            default:
                mapView.mapType = MKMapType.Standard
        }
    }

}

