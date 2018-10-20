//
//  CustomGridViewController.swift
//  MyIns
//
//  Created by CHING MAN LEE on 15/10/2018.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class CustomGridViewController: UIView {
    
    //let gridLayer = GridViewController.self
    
    
    private weak var gridLayer : CALayer?
    private var gridColor : UIColor = UIColor.gray
    private var gridLineWidth : CGFloat = 1
    private var gridSize : CGSize = CGSize(width: 80, height: 80)
    private var gridOrigin : CGPoint = CGPoint(x: 0, y: 0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let gridLayer = self.gridLayer{
            gridLayer.removeFromSuperlayer()
        }
        
        let grid = UIBezierPath()
        
        let screenWidth = frame.size.width
        let screenHeight = frame.size.height
        let previewHeight = screenWidth + (screenWidth / 3)
        //let totalBlack = screenHeight - previewHeight
        //let heightOfBlackTopAndBottom = totalBlack / 2
        
        let numberOfColumns = 2
        for index in 1...numberOfColumns {
            let xPos = gridOrigin.x + (screenWidth/3 * CGFloat(index))
            let startPoint = CGPoint(x: xPos, y: gridOrigin.y)
            let endPoint = CGPoint(x: xPos, y: gridOrigin.y + previewHeight)
            grid.move(to: startPoint)
            grid.addLine(to: endPoint)
        }
        
        let numberOfRows = 2
        for index in 1...numberOfRows {
            let yPos = gridOrigin.y + (screenHeight/3 * CGFloat(index))
            let startPoint = CGPoint(x: gridOrigin.x, y: yPos)
            let endPoint = CGPoint(x: screenWidth, y: yPos)
            grid.move(to: startPoint)
            grid.addLine(to: endPoint)
        }
        
        let gridLayer = CAShapeLayer()
        gridLayer.frame = frame
        gridLayer.path = grid.cgPath
        gridLayer.strokeColor = gridColor.cgColor
        gridLayer.lineWidth = gridLineWidth
        self.layer.addSublayer(gridLayer)
        //self.gridLayer = gridLayer
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
