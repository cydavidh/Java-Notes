first in first out

            ============================================
dequeue <---      first, second, third, last       <------ enqueue
            ============================================

unlike stack, queue is an interface. often implemented by linked list.

```java
Queue<Integer> queue = new LinkedList<>();
queue.offer(10); //add to end
queue.poll(); //remove and return first element
queue.peek(); //view first element
```