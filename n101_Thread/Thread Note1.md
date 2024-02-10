Creating and starting threads in Java can be done by extending `Thread` class or implementing `Runnable` interface. Use `Thread.start()` to run code in a separate thread. The main thread and new threads run concurrently, without a guaranteed execution order. Use `Thread.join()` to make one thread wait for another to finish.

- Extending `Thread`:
```java
class HelloThread extends Thread {
    @Override
    public void run() { System.out.println("Hello, I'm " + getName()); }
}
```
- Implementing `Runnable`:
```java
class HelloRunnable implements Runnable {
    @Override
    public void run() { System.out.println("Hello, I'm " + Thread.currentThread().getName()); }
}
```
- Starting threads:
```java
Thread t1 = new HelloThread();
Thread t2 = new Thread(new HelloRunnable());
t1.start();
t2.start();
```

Threads share heap space, allowing access to common objects. Synchronization is crucial when multiple threads manipulate shared data to prevent inconsistencies.

# sleep
Sleeping: `Thread.sleep(milliseconds)` pauses the current thread, freeing up CPU for others. Use `TimeUnit.SECONDS.sleep(seconds)` for readability.

# join
Joining Threads: `Thread.join()` makes current thread wait for another to finish. Use `thread.join(milliseconds)` to set a max wait time.

# exception
So if there' s another non-daemon thread running, even if the main thread runs into an uncaught exception, it won't terminate the program
if main thread uncaught error, finish with code 1 (error), other threads will still run.

# thread interference
`Counter` class with value of 0;
`MyThread` class with counter field, counter in constructor parameter, that increases counter by one.
two MyThread instances run same time, conflict happens because both effect the counter instance at the same time. Maybe both thread get counter = 0 and increase to 1 same time.
increment and decrement are always non-atomic. volatile keyword won't help.

# volatile
volatile is used to make `long` and `double` assignment atomic. `volatile long = 1234L`
volatile is used to make changes of a value visible to other threads
int number = 0
thread1 makes number += 5
thread2 print System.out.println(number); might still be 0
so `volatile int number = 0`; solves this problem.

# synchronized keyword
Thread synchronization
Important terms and concepts
```java
public static long counter = 0;
Static synchronized methods
class SomeClass {
    public static synchronized void doSomething() {
        String threadName = Thread.currentThread().getName();
        System.out.println(String.format("%s entered the method", threadName));
        System.out.println(String.format("%s leaves the method", threadName));
    }
}
```
Instance synchronized methods
```java
class SomeClass {
    private String name;

    public SomeClass(String name) {
        this.name = name;
    }

    public synchronized void doSomething() {
        String threadName = Thread.currentThread().getName();
        System.out.println(String.format("%s entered the method of %s", threadName, name));
        System.out.println(String.format("%s leaves the method of %s", threadName, name));
    }
}
```
Synchronized blocks (statements)
```java
class SomeClass {
    public static void staticMethod() {
        // unsynchronized code
        ...
        synchronized (SomeClass.class) { // synchronization on object of SomeClass class
            // synchronized code
            ...
        }
    }

    public void instanceMethod() {
        // unsynchronized code
        ...
        synchronized (this) { // synchronization on this instance
            // synchronized code
            ...
        }
    }
}
```