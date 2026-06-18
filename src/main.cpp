#include <concurrentqueue/concurrentqueue.h>

#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;

    moodycamel::ConcurrentQueue<int> queue;
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    int value = 0;
    while (queue.try_dequeue(value)) {
        std::cout << "Dequeued: " << value << std::endl;
    }

    return 0;
}
