//
//  GameControlView.swift
//  VIews
//
//  Created by Timur Saidov on 11/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

@IBDesignable
class GameControlView: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    // Функция загрузки View из Xib.
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GameControlView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return UIView() }
        return view
    }
}
