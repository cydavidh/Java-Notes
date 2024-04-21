package cydavidh.sandbox.s01multithreaded;

class HelloThread extends Thread {

    @Override
    public void run() {
        String helloMsg = String.format("Hello, I'm %s", getName());
        System.out.println(helloMsg);
    }
}

//public static void main(String[] args) {
//    Thread HelloThread = new HelloThread();
//    HelloThread.start();
//}