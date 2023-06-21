//
//  ONVlcController.swift
//  One Store Player
//
//  Created by MacBook Pro on 16/01/2023.
//
import SwiftUI
import UIKit
import MobileVLCKit
import MediaPlayer
import TactileSlider


struct VLCView:UIViewControllerRepresentable {
    var link:String
    var isOvarLayHide:Bool
    func makeUIViewController(context: Context) -> ONVlcController {
        let vc = ONVlcController(nibName: "ONVlcController", bundle: nil)
        vc.urlLink = link
        vc.isOvarLayHide = isOvarLayHide
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ONVlcController, context: Context) {
        uiViewController.urlLink = link
        uiViewController.isOvarLayHide = isOvarLayHide
        
    }
    typealias UIViewControllerType = ONVlcController
    
}

class ONVlcController: UIViewController {
    @IBOutlet weak private var vlcView: UIView!
    {
        didSet {
            vlcView.isUserInteractionEnabled = true
            vlcView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControl)))
        }
    }
    @IBOutlet weak private var controls: UIView!
    {
        didSet {
            controls.isUserInteractionEnabled = true
            controls.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControl)))
        }
    }
    @IBOutlet weak private var slider: UISlider!
    @IBOutlet weak private var playPauseButton: UIButton!
    @IBOutlet weak private var LabelcurrenT: UILabel!
    @IBOutlet weak private var LabelTotalT: UILabel!
    @IBOutlet weak private var volumneSlider:TactileSlider!
    @IBOutlet weak private var brightnessSlider:TactileSlider!
    @IBOutlet weak private var indicator:UIActivityIndicatorView!
    
    var urlLink:String!{
        didSet{
            startStream()
        }
    }
    var isOvarLayHide: Bool = false
    let videoPlayer = VLCMediaPlayer()
    
    @objc private func hideControl(){
        if controls.isHidden {
            controls.isHidden = false
        }
        else {
            controls.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startStream()
        videoPlayer.delegate = self
        if isOvarLayHide {
            vlcView.isUserInteractionEnabled = false
            controls.isHidden = true
            self.videoPlayer.play()
        }
    }

    func startStream(){
      guard let url = URL(string:urlLink) else {return}
      videoPlayer.drawable = vlcView
      videoPlayer.media = VLCMedia(url: url)
       
    }

    func setupOverlay( player:  VLCMediaPlayer){
        guard let grandtotal = player.media?.length.value else { return }
        guard let guardcurrent = player.time.value else { return }
        self.slider.maximumValue = Float(truncating: grandtotal) / 100
        self.slider.value = Float(truncating: guardcurrent) / 100
        self.slider.isContinuous = true
        
        let current = player.time
        guard let total = player.media?.length else {return}
        
        self.LabelcurrenT.text = "\(current)"
        UserDefaults.standard.set(Float(truncating: guardcurrent) / 100, forKey: urlLink)
        self.LabelTotalT.text = "\(total)"
    }
    
    //MARK: - IBAction
    @IBAction func playPause(sender: UIButton){
        if self.videoPlayer.state == .stopped {
            startStream()
            self.videoPlayer.play()
            sender.isSelected = true
        }else {
            if sender.isSelected {
                self.videoPlayer.pause()
                sender.isSelected = false
                self.indicator.stopAnimating()
                self.controls.isHidden = false
            }else{
                self.videoPlayer.play()
                sender.isSelected = true
                self.indicator.startAnimating()
                self.controls.isHidden = true
            }
        }
        
    }
    
    @IBAction func didSeekBarValueCHange(sender: UISlider){
        let timeStart = Double(sender.value)
        let range = Float(truncating: self.videoPlayer.media?.length.value ?? 0.0)/100
        let perCent = (Float(timeStart) / range)
        self.videoPlayer.position = Float(perCent)
    }
    
    @IBAction func forwardTapped(_ sender: UIButton){
        self.videoPlayer.jumpForward(10)
    }
    
    @IBAction func backwardTapped(_ sender: UIButton){
        if videoPlayer.state == .stopped {
            startStream()
            self.videoPlayer.play()
        }else {
            self.videoPlayer.jumpBackward(10)
        }
        
    }
    
    @IBAction private func volumeSlider(){
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider
        {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                view.value = self.volumneSlider.value
            }
        }
        
    }
    
    @IBAction private func brightnessAdjust()
    {
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
        
    }
    
    deinit {
        self.videoPlayer.pause()
    }
    
}
extension ONVlcController:VLCMediaPlayerDelegate{
    
    
    
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        guard let videoPlayer = aNotification.object as? VLCMediaPlayer else {return}
        switch videoPlayer.state{
        case .playing:
            print("VLCMediaPlayerDelegate: PLAYING")
            if let value = UserDefaults.standard.value(forKey: urlLink) as? Float {
                debugPrint("Save Value \(value)")
                let timeStart = Double(value)
                let range = Float(truncating: self.videoPlayer.media?.length.value ?? 0.0)/100
                let perCent = (Float(timeStart) / range)
                self.videoPlayer.position = Float(perCent)
                //self.videoPlayer.position = value
                
            }
            self.indicator.stopAnimating()
            self.controls.isHidden = false
        case .opening:
            print("VLCMediaPlayerDelegate: OPENING")
            
            self.indicator.startAnimating()
            self.controls.isHidden = true
            
        case .error:
            print("VLCMediaPlayerDelegate: ERROR")
            self.playPauseButton.isSelected = false
            self.indicator.stopAnimating()
            self.controls.isHidden = false
            
        case .buffering:
            print("VLCMediaPlayerDelegate: BUFFERING")
            
        case .stopped:
            print("VLCMediaPlayerDelegate: STOPPED")
            self.playPauseButton.isSelected = false
        case .paused:
            print("VLCMediaPlayerDelegate: PAUSED")
            self.playPauseButton.isSelected = false
        case .ended:
            print("VLCMediaPlayerDelegate: ENDED")
            self.playPauseButton.isSelected = false
        case .esAdded:
            print("VLCMediaPlayerDelegate: ELEMENTARY STREAM ADDED")
        default:
            break
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification) {
        guard let videoPlayer = aNotification.object as? VLCMediaPlayer else {return}
        self.setupOverlay(player: videoPlayer)
    }
    
    

   
}
