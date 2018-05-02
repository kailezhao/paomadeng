//
//  LLMarqueeView.swift
//  跑马灯
//
//  Created by zhaokaile on 2018/4/25.
//  Copyright © 2018年 zhaokaile. All rights reserved.
//
@objc
protocol LLMarqueeViewDelegate{
    //MARK -
    @objc optional func mqrqueeView(_ marqueeView:LLMarqueeView ,didSelectCellAt index:Int) -> Void
}

protocol LLMarqueeViewDataSource {
    //MARK
    func numberOfItems(_ marqueeView:LLMarqueeView) -> Int
    func marqueeView(_ marqueeView:LLMarqueeView,cellForItemAt index:Int) -> NSAttributedString
}

import UIKit

class LLMarqueeView: UIView {
    //MARK:
    var curtIdx:Int = 0
    weak var delegate:LLMarqueeViewDelegate?
    var dataSource:LLMarqueeViewDataSource?
    
    
    //MARK:
    let marqueeOneLab = UILabel()
    let marqueeTwoLab = UILabel()
    var timer:Timer?
    
    var automaticSlidingInterval:CGFloat = 0.0{//属性观察器
        didSet{
            print("时钟是\(self.automaticSlidingInterval)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.setUpUI()
        
    }
    
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI
    func setUpUI() -> Void {
        marqueeOneLab.font = UIFont.systemFont(ofSize: 13)
        marqueeTwoLab.font = UIFont.systemFont(ofSize: 13)
        marqueeOneLab.textColor = UIColor.red
        marqueeTwoLab.textColor = UIColor.red
        marqueeOneLab.backgroundColor = UIColor.yellow
        marqueeTwoLab.backgroundColor = UIColor.orange
        
        self.addSubview(marqueeOneLab)
        self.addSubview(marqueeTwoLab)
        
        
        marqueeOneLab.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        marqueeTwoLab.frame = CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        
        let tapAction:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapAction(_:)))
        self.addGestureRecognizer(tapAction)
    }
    
   @objc func tapAction(_ tapAction:UITapGestureRecognizer) -> Void {
        if let _ = delegate{
            delegate!.mqrqueeView!(self, didSelectCellAt: curtIdx)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        marqueeOneLab.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        marqueeTwoLab.frame = CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
//    }
    
    
}

//MARK: - 扩展
extension LLMarqueeView{
    
    func cancleTimer() -> Void {
        guard self.timer != nil else {
            return
        }
        self.timer!.invalidate()
        self.timer = nil
    }
    
    func startTimer(){
        print("开启定时器")
        self.timer = Timer.scheduledTimer(timeInterval:TimeInterval(self.automaticSlidingInterval) , target: self, selector:#selector(self.flipNext(_:)), userInfo: nil, repeats: true)
    }
    
    func reload() -> Void {
        guard let _ = delegate  ,let _ = dataSource else {
            print("代理delegate或则数据源dataSource没有设置")
            return
        }
        let numOfItems = self.dataSource!.numberOfItems(self)
        guard numOfItems > 0 else {
            print("没有需要显示的marqueeView")
            return
        }
        print("deleate and datasource set ok")
        self.cancleTimer()
        self.initStatusMarquee(0)
    }
    //MARK:- 先初始化第一次显示，然后等待时钟fire
    func initStatusMarquee(_ startInx:Int) -> Void {
        let counts = dataSource!.numberOfItems(self)
        self.marqueeOneLab.attributedText = dataSource!.marqueeView(self, cellForItemAt: startInx)
        guard counts > startInx else {
            return
        }
        //数目大于一个可以循环
        curtIdx = startInx + 1
        marqueeTwoLab.attributedText = dataSource!.marqueeView(self, cellForItemAt: startInx+1)
        self.startTimer()
    }
    
    @objc func flipNext(_ sender:Timer){
        print("进来了!!!");
        UIView.animate(withDuration: 0.75, animations: {
            let oneOriY = self.marqueeOneLab.frame.origin.y
            let twoOriY = self.marqueeTwoLab.frame.origin.y
            
            if oneOriY > twoOriY {
                var rectOne:CGRect = self.marqueeTwoLab.frame
                rectOne.origin.y = -rectOne.size.height
                self.marqueeTwoLab.frame = rectOne
                
                var rectTwo:CGRect = self.marqueeOneLab.frame
                rectTwo.origin.y = 0
                self.marqueeOneLab.frame = rectTwo
                
            }else{
                var rectOne:CGRect = self.marqueeOneLab.frame
                rectOne.origin.y = -rectOne.size.height
                self.marqueeOneLab.frame = rectOne
                
                var rectTwo = self.marqueeTwoLab.frame
                rectTwo.origin.y = 0
                self.marqueeTwoLab.frame = rectTwo
                
            }
        }){(true) in
            let oneOriY = self.marqueeOneLab.frame.origin.y
            let twoOriY = self.marqueeTwoLab.frame.origin.y
            let l:UILabel?
            if oneOriY < twoOriY{
                l = self.marqueeOneLab
            }else{
                l = self.marqueeTwoLab
            }
            
            var rectOne:CGRect = l!.frame
            rectOne.origin.y = rectOne.size.height
            l!.frame = rectOne
            
            if(self.curtIdx+1<self.dataSource!.numberOfItems(self)){
               l!.attributedText = self.dataSource!.marqueeView(self, cellForItemAt: self.curtIdx + 1)
                self.curtIdx = self.curtIdx+1
            }else if(self.curtIdx+1 == self.dataSource!.numberOfItems(self)){
                l!.attributedText = self.dataSource!.marqueeView(self, cellForItemAt: 0)
                self.curtIdx = 0
            }else{}
            //====END====
        }
        
    }
    
}
