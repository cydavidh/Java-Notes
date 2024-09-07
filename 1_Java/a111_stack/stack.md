First in last out.
like a U shaped cup with only one opening.

```java
Stack<Integer> stack = new Stack<>();

stack.push(10);
stack.pop(); //remove and return top element
stack.peek(); //view top element
stack.isEmpty();
stack.size();
```

stack is a class, queue is an interface. reasons include time of introduction (stack old), design philosophy evolution (interfaces favored to allow for multiple implementation), and flexibility(multiple implementations).

so the new stack is Deque.

```java
Deque<Integer> stack = new ArrayDeque<>();
//below are all methods of Deque.
-----------------------------------
stack name  |  queue method name
-----------------------------------
push()      |  addFirst()
pop()       |  removeFirst()
peek()      |  getFirst()
```

A Deque can function as both a queue (FIFO - First-In-First-Out) and a stack (LIFO - Last-In-First-Out).

It provides all the functionality of a Stack (push, pop, peek) with better performance.
Unlike the legacy Stack class, Deque is designed as an interface, allowing for multiple implementations (like ArrayDeque).