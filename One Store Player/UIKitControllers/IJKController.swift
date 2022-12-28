//
//  IJKController.swift
//  One Store Player
//
//  Created by MacBook Pro on 26/12/2022.
//

import UIKit
import IJKMediaFramework
class IJKController: UIViewController {
    var player:IJKFFMoviePlayerController!
    var url:URL = .init(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        play(url)
    }

    fileprivate func play(_ url: URL?) {
        let options = IJKFFOptions.byDefault()
        
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url!, with: options)
        //播放页面视图宽高自适应
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        player?.view.frame = self.view.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.view.autoresizesSubviews = true
        self.view.addSubview((player?.view)!)
        self.player = player
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player.prepareToPlay()
        self.player.play()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                //关闭播放器
                self.player.shutdown()
    }

}
