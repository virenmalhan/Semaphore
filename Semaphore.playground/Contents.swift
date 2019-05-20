import UIKit
import XCPlayground
import PlaygroundSupport


let q1 = DispatchQueue(label: "q1", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
let q2 = DispatchQueue(label: "q2", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)

var count = 0
// Semaphore is created using value 1. Value 0 will block all the threads to access the shared resource. value 1 will allow 1 thread at a time.
let semaphore = DispatchSemaphore(value: 1)

func increment(queue: DispatchQueue) {
    count = count + 1
    print(" write count: \(count) in queue: \(queue.label)")
}

func read(queue: DispatchQueue) {
    print(" read count: \(count) in queue: \(queue.label)")
}

func perform(queue: DispatchQueue) {
    semaphore.wait() // Increments semaphore count. if the value provided to semaphore equals the semaphore count. semaphore stop any more thread to access the critical section.
    increment(queue: queue)
    read(queue: queue)
    semaphore.signal() // Decrement semaphore count. Hence threads can again be allowed to access the critical section.
}

for _ in 1...5 {
    q1.async {
        perform(queue: q1)
    }
    q2.async {
        perform(queue: q2)
    }
}
