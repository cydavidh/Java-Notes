Thread thread = Thread.currentThread();
thread.getName();
thread.getPriority();

```java
class HelloThread extends Thread {

    @Override
    public void run() {
        String helloMsg = String.format("Hello, I'm %s", getName());
        System.out.println(helloMsg);
    }
}
```
```java
Thread t = new HelloThread(); // an object representing a thread
t.start();
```
start schedules thread for execution by JVM.
run runs the run() method's code on the current thread, like a normal method call, defeat purpose.

Eventually, after a short pause, it prints something like:
```
Hello, I'm Thread-0 
```
when call start, JVM decides when to execute it. this scheduling produces a delay.
```java
public class StartingMultipleThreads {

    public static void main(String[] args) {
        Thread t1 = new HelloThread();
        Thread t2 = new HelloThread();

        t1.start();
        t2.start();

        System.out.println("Finished");
    }
}
```
The order of displaying messages may be different. Here is one of them:
```
Hello, I'm Thread-1
Finished
Hello, I'm Thread-0

Finished
Hello, I'm Thread-0
Hello, I'm Thread-1

```
===================================================================================================================================================
if thread throws exception that is not caught, then thread terminates.
and if the program is single threaded and this happens, the program terminates.
like when this happens in main thread
```java
public class SingleThreadProgram {
    public static void main(String[] args) {
        System.out.println(2 / 0);
    }
}
```
```
This program outputs:

Exception in thread "main" java.lang.ArithmeticException: / by zero
  at org.example.multithreading.exceptions.SingleThreadProgram.main(SingleThreadProgram.java:6)

Process finished with exit code 1
```


but this is another story if this happens in another thread that is daemon.
```
public class ExceptionInThreadExample {
    public static void main(String[] args) throws InterruptedException {
        Thread thread = new CustomThread();
        thread.start();
        thread.join(); // wait for thread with exception to terminate
        System.out.println("I am printed!"); // this line will be printed
    }
}

class CustomThread extends Thread {

    @Override
    public void run() {
        System.out.println(2 / 0);
    }
}
```
the main thread will still print the line 79, even if the custom thread throws exception and not caught.

<!-- 
try {
    System.out.println(2 / 0);
} catch (Exception e) {
    System.err.println("An error occurred: " + e.getMessage()); //log error
    //or
    throw new RuntimeException(e); // propagate up call stack
} 
-->


So if there' s another non-daemon thread running, even if the main thread runs into an uncaught exception, it won't terminate the program

if main thread uncaught error, finish with code 1 (error), other threads will still run.


Thread.sleep(1000L);

thread.join();