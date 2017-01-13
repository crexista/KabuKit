//
//  Copyright © 2017 crexista
//

import Foundation

import XCTest
import Quick
import Nimble

@testable import KabuKit

class ProducerSpec: QuickSpec {
    
    override func spec() {
        
        class MockScenario: Scenario {
            
            func start(producer: Producer) {

            }
            
            func describe<E, S>(_ event: E, from sequence: SceneSequence<S>, through producer: Producer?) {

            }
            
        }
        
        
        describe("Producerの生成について") {
            
            context ("初期化時にScenarioを渡さない場合") {
                
                it("Scenarioを持たないProducerが生成される") {
                    let scene = SimpleMockScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let producer = Producer.run(sequence: sequence)
                    expect(producer.scenario).to(beNil())
                    expect(producer.sequence!) === sequence
                }
            }
            
            context ("初期化時にScenarioを渡した場合") {
                it("Scenario内部にSequenceを持つためProducer自体はSequenceを内部に持たない") {
                    let producer = Producer.run(scenario: MockScenario())
                    expect(producer.scenario).notTo(beNil())
                    expect(producer.sequence).to(beNil())
                }
            }
        }
        
        describe("Sequencenの実行について") {
            
            context ("すでに起動済みのSequenceを渡した場合") {
               
                it("falseを返し何もしない") {
                    let scene = SimpleMockScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let producer = Producer.run(sequence: sequence)
                    let result = producer.startSequence(sequence: sequence)
                    expect(result).to(beFalse())
                    expect((producer.sequence as? SceneSequence<NSObject>)?.isStarted).to(beTrue())
                }
            }
            
            context ("まだ起動してないSequenceを渡した場合") {
                
                it("trueを返しSequenceを起動させる") {
                    let scene = SimpleMockScene()
                    let sequence = SceneSequence(NSObject(), scene, nil){ (stage, scene) in }
                    let producer = Producer.run(scenario: MockScenario())
                    expect(sequence.isStarted).to(beFalse())
                    expect(producer.startSequence(sequence: sequence)).to(beTrue())
                    expect(sequence.isStarted).to(beTrue())

                }
            }

            
        }
        
    }
}
