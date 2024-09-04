public class Node {
    Node next;
    int data; 
    public Node(int data) {
        this.data = data;
    }

    public void append(int data) {
        Node current = this;
        while (current.next != null) {
            current = current.next;
        }
        current.next = new Node(data);
    }

    public Node getNode(int index) {
        Node current = this;
        for (int i = 0; i < index; i++) {
            current = current.next;
        }
        return current;
    }

    public void prepend(int data) {
        Node head = new Node(data);
        head.next = this;
    }

    public static void main(String[] args) {
        
    }
}