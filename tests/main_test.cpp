#include <concurrentqueue/concurrentqueue.h>
#include <gtest/gtest.h>

TEST(SampleTest, BasicAssertion) {
    EXPECT_EQ(1 + 1, 2);
}

TEST(SampleTest, DistinctValues) {
    EXPECT_NE(1, 2);
}

TEST(ConcurrentQueueTest, PushPop) {
    moodycamel::ConcurrentQueue<int> queue;

    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    int value = 0;
    EXPECT_TRUE(queue.try_dequeue(value));
    EXPECT_EQ(value, 1);

    EXPECT_TRUE(queue.try_dequeue(value));
    EXPECT_EQ(value, 2);

    EXPECT_TRUE(queue.try_dequeue(value));
    EXPECT_EQ(value, 3);

    EXPECT_FALSE(queue.try_dequeue(value));
}
