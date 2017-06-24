# KabuKit
[![Build Status](https://travis-ci.org/crexista/KabuKit.svg?branch=master)](https://travis-ci.org/crexista/KabuKit)
[![codecov](https://codecov.io/gh/crexista/KabuKit/branch/master/graph/badge.svg)](https://codecov.io/gh/crexista/KabuKit)  
KabuKit is Simple & Tiny Application's Transition Framework  

## Introduction

KabuKitはアプリケーションの画面遷移時のルーティングと  
その際に各画面で必要となっている値渡しを行うシンプルなフレームワークです。

## Requirements
- Xcode 8.3.2+
- Swift 3.0+

**このREADME.mdはまだ完全ではありません、以下はまだ書き途中です**

-----

## About Architecture

![kabukit_architecture](https://user-images.githubusercontent.com/1249559/27511306-0423501c-595c-11e7-97ef-db8fde03058d.png)

## Get Start (example)

1. 遷移元の画面と遷移先の画面にSceneを実装します
  ``` swift
  //遷移元
  extension FromViewController : Scene {
    typealias contextType : Void
  }
  // 遷移先
  extension ToViewController: Scene {
    typealias contextType: String
  }
  ```
2. 画面から飛ばすリクエストの設定します
  ```swift
  class TrasitRequest: Request<String>()

  extension FromViewController : Scene {
    typealias contextType : String

    @IBAction func onTapNext(sender: UIButton) {
      send(TransitRequst("hello"))
    }
  }
  ```
3. ルーティング
  ```swift
  class SampleGuide {
    typealias Stage = UINavigationController

    func start(with operation: SceneOperation<UINavigationController>) {

      operation.at(Sample1ViewController.self) { s in

        s.given(Sample2Request.self) { (args) in
           args.stage.pushViewController(args.next, animated: true)
           return {
              args.stage.popViewController(animated: true)
           }
        }

      }
    }
  }
  ```
