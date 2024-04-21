package cydavidh.sandbox.s01multithreaded;


public class SimpleMultithreadedProgram {

    public static void main(String[] args) {
        Thread worker = new SquareWorkerThread("square-worker");
        worker.start(); // start a worker (not run!)

        long startTime = System.currentTimeMillis();
        long interval = 2000; // 10 seconds

        while (true) {
            if (System.currentTimeMillis() - startTime > interval) {
                System.out.println("Hello from the main thread!");
                startTime = System.currentTimeMillis(); // Reset start time
            }
        }
    }
}