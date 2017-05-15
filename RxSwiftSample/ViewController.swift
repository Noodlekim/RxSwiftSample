//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by Kim Gibong on 2017/05/10.
//  Copyright © 2017年 Kim Gibong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// VC -- VM -- Model 構造でVCからアクションを受けてObserveで値をx20する仕組みをテストしてみた
/// 本来ならVM側でRequest処理やModelの更新などをちゃんとしなければいけないです。
struct Model {
    var number: Variable<Double> = Variable(100.0)
}

class ViewModel2 {
    
    var model = Model.init()
    
    var observer: Observable<Double> {
        return model.number.asObservable()
    }
    init() { }
    
    func updateValues() {
        self.model.number.value = self.model.number.value * 20
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    var viewModel2: ViewModel2 = ViewModel2()
    var disposeBag = DisposeBag()
    var tempDispose: Disposable?
    var count: Int = 0
    
    @IBAction func tap(_ sender: Any) {
        viewModel2.updateValues()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel() {
        
/// タップされるたびに x20 かける
        viewModel2.observer
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (number) in
                print("next \(number)")
            })
            .addDisposableTo(disposeBag)

/// 5回以上呼ばれたらDisposeする処理
//        self.tempDispose = viewModel2.observer
//            .subscribe { (event) in
//                switch event {
//                case .next(let value):
//                    print("next \(value)")
//                    self.count += 1
//                    if self.count > 5 {
//                        self.tempDispose?.dispose()
//                    }
//                case .completed:
//                    print("completed")
//                case .error(let error):
//                    print(error)
//                }
//            }
    }
}

