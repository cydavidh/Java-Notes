package cydavidh.sandbox.s01multithreaded;


class CustomThread extends Thread {

    @Override
    public void run() {
        try {
            System.out.println(2 / 0);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

//public class Main {
//    public static void main(String[] args) throws InterruptedException {
//        Thread thread = new CustomThread();
//        thread.start();
//        thread.join(); // wait for thread with exception to terminate
//        System.out.println("I am printed!"); // this line will be printed
//    }
//}