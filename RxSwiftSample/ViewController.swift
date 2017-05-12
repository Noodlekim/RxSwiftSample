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

protocol ViewModelInput {
    func request1()
    func request2()
    func request3()
}
protocol ViewModelOutput {
    var number: Observable<Int> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

struct Model {
    var number = Variable(100)
}

class ViewModel: ViewModelInput, ViewModelOutput, ViewModelType {
    let model: Model
    
    
    init() {
        model = Model()
        self.number = model.number.asObservable()
    }
    
    let number: Observable<Int>
    
    var inputs: ViewModelInput { return self }
    var outputs: ViewModelOutput { return self }
}



class ViewModel2 {
    
    var model = Model.init()
    
    var number1: Observable<Int> {
        return model.number.asObservable()
    }
    var number2: Observable<Int> {
        return model.number.asObservable()
    }
    init() {

    }
    
    func updateValues() {
        self.model.number = Variable(model.number.value*20)
    }
}

extension ViewModel {
    func request1() {
        
    }
    func request2() {
        
    }
    func request3() {
        
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    var viewModel: ViewModel!
    var viewModel2: ViewModel2 = ViewModel2()
    let disposeBag = DisposeBag()
    
    @IBAction func tap(_ sender: Any) {
        viewModel2.updateValues()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    func bind() {
        
        viewModel2.number1
            .map({ $0 })
            .subscribe(onNext: { (newNumber) in
                print("newNumber > \(newNumber)")
            }, onError: { (error) in
                print("error \(error)")
            }, onCompleted: { 
                print("complete!")
            }, onDisposed: { 
                print("disposed!")
            })
//            .addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

