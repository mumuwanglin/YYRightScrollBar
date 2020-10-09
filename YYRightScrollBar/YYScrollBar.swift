//
//  YYScrollBar.swift
//  YYRightScrollBar
//
//  Created by mumu on 2020/9/16.
//  Copyright © 2020 mumu. All rights reserved.
//

import UIKit

protocol YYScrollBarDelegate: NSObjectProtocol {
    func scrollBarDidScroll(scrollBar: YYScrollBar, rollingRatio: CGFloat)
}

class YYScrollBar: UIView {
    // 滑块滚动的比例
    var scrollViewRotio: CGFloat? {
        didSet {
            showingFastRollingFlag = true
            if isShowFastRollingBtn() {
                followScrollView()
            } else {
                followScrollView()
                showFastRollingBtnWithAnimation()
            }
        }
    }
    
    // 滚动代理
    weak var delegate: YYScrollBarDelegate?
    // 是否展示滑块
    var showingFastRollingFlag = false
    
    // 滑块的宽度
    private var fastRollingWidth: CGFloat = 26
    // 滑块的高度
    private var fastRollingHeight: CGFloat = 42
    private var lastDragPoint: CGFloat = 0
    private var autoHidingFastRollingBtnFlag = true
    
    // 自定义滑块
    lazy var fastRollingButton: UIButton = {
        let tmp = UIButton(type: .custom)
        tmp.frame = CGRect.init(x: 0, y: 0, width: 26, height: 42)
        tmp.setImage(UIImage.init(named: "read_catalog_white_slider"), for: .normal)
        tmp.adjustsImageWhenHighlighted = false
        tmp.isHidden = false
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:)))
        tmp.addGestureRecognizer(panGestureRecognizer)
        return tmp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(fastRollingButton)
    }
    
    // 是否正在展示滑块
    private func isShowFastRollingBtn() -> Bool {
        return fastRollingButton.frame.origin.x == 0
    }
    
    // 更新滑块的位置
    private func updateFasetRollingBtnFrame() {
        self.fastRollingButton.frame = CGRect(x: 0, y: self.fastRollingButton.frame.origin.y, width: self.fastRollingWidth, height: self.fastRollingHeight)
    }
    
    // 显示滑块
    private func showFastRollingBtnWithAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.updateFasetRollingBtnFrame()
        })
    }
    
    // 隐藏滑块
    private func hideFastRollingBtnWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            if self.showingFastRollingFlag {
               return
            }
            UIView.animate(withDuration: 0.2, animations: {
                if self.showingFastRollingFlag {
                   return
                }
                let tmpX = self.fastRollingButton.frame.origin.x
                self.fastRollingButton.frame = CGRect(x: tmpX + self.fastRollingWidth, y: self.fastRollingButton.frame.origin.y, width: self.fastRollingWidth, height: self.fastRollingHeight)
            })
        })
    }
    
    // 滚动scrollview 调整快速滑块位置
    private func followScrollView() {
        let rotio = scrollViewRotio ?? 0
        var frame = self.fastRollingButton.frame
        frame.origin.y = (self.frame.size.height - fastRollingHeight) * rotio
        fastRollingButton.frame = frame
    }
    
    // 跟随手势事件
    @objc private func handlePan(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .ended {
            lastDragPoint = 0
            checkHideFastRollingBtn()
        } else {
            let pointY: CGFloat = panGesture.translation(in: panGesture.view).y
            let offset: CGFloat = pointY - self.lastDragPoint
            lastDragPoint = pointY
            
            var frame = self.fastRollingButton.frame
            let maxY = self.frame.size.height - fastRollingHeight
            
            frame.origin.y = frame.origin.y > maxY ? maxY : frame.origin.y + offset
            frame.origin.y = frame.origin.y <= 0 ? 0 : frame.origin.y
            frame.origin.y = frame.origin.y >= maxY ? maxY : frame.origin.y
            
            self.fastRollingButton.frame = frame
            
            let ratio = frame.origin.y / (self.bounds.size.height - fastRollingHeight)
            delegate?.scrollBarDidScroll(scrollBar: self, rollingRatio: ratio)
        }
    }
    
    // 隐藏滑块
    func checkHideFastRollingBtn() {
        if isShowFastRollingBtn() {
            showingFastRollingFlag = false
            hideFastRollingBtnWithAnimation()
        }
    }
    
    // Scroll滚动，计算滑块位置
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollViewRotio = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.frame.size.height)
        scrollViewRotio = scrollViewRotio >= 1 ? 1 : scrollViewRotio
        scrollViewRotio = scrollViewRotio <= 0 ? 0 : scrollViewRotio
        self.scrollViewRotio = scrollViewRotio
    }
}
