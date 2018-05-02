//
//  ViewController.swift
//  跑马灯
//
//  Created by zhaokaile on 2018/4/25.
//  Copyright © 2018年 zhaokaile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LLMarqueeViewDelegate, LLMarqueeViewDataSource {
    
    let marqueeView = LLMarqueeView.init(frame: CGRect.init(x: 0, y: 100, width: 375, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.marqueeView.automaticSlidingInterval = 3
        self.marqueeView.delegate = self
        self.marqueeView.dataSource = self
        self.view.addSubview(self.marqueeView)
        self.readyDataSource()
    }
    func readyDataSource() -> Void {
        marqueeView.reload()
    }
    //MARK: - 跑马灯View 代理  LLMarqueeViewDataSource ==========
    func numberOfItems(_ marqueeView: LLMarqueeView) -> Int {
        return 3
    }
    func marqueeView(_ marqueeView: LLMarqueeView, cellForItemAt index: Int) -> NSAttributedString {
        if index == 0 {
            
            let str = "【我只是说说而已】"
            let fullStr = "\(str) 提现了100.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: r)
            return att
            
        }else if index == 1{
            
            let str = "【梦想只是说说而已】"
            let fullStr = "\(str) 提现了200.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: r)
            return att
        }else{
            
            let str = "【梦想就是梦】"
            let fullStr = "\(str) 提现了900.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.purple, range: r)
            return att
        }
    }
    //MARK LLMarqueeViewDelegate =====
    func mqrqueeView(_ marqueeView: LLMarqueeView, didSelectCellAt index: Int) {
        print(index);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

