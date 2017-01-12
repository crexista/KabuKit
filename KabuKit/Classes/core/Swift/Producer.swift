//
//  Copyright © 2017 crexista
//

import Foundation

public class Producer {
    
    internal let scenario: Scenario?
    
    private let sequence: AnyObject?
    
    private init<S: AnyObject>(sequence: SceneSequence<S>) {
        self.scenario = nil
        self.sequence = sequence
    }
    
    private init(scenario: Scenario) {
        self.scenario = scenario
        self.sequence = nil
    }
    
    /**
     指定のSequenceをスタートさせます
     
     */
    public func startSequence<S>(sequence: SceneSequence<S>) {
        sequence.start(producer: self)
    }
    
    /**
     指定のScequenceを初期化及び、startさせ、Producerオブジェクトを生成させる
     Factoryメソッドです
     
     */
    public static func run<S: AnyObject>(sequence: SceneSequence<S>) -> Producer {
        let producer = Producer(sequence: sequence)
        producer.startSequence(sequence: sequence)

        return producer
    }

    public static func run(scenario: Scenario) -> Producer {
        let producer = Producer(scenario: scenario)
        scenario.start(producer: producer)
        
        return producer
    }

}
