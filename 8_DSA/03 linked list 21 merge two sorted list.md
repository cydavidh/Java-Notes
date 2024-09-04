```java

public class Sandbox {
    public static void main(String[] args) {
        ListNode list1 = new ListNode(1);
        list1.next = new ListNode(2);
        list1.next.next = new ListNode(4);

        ListNode list2 = new ListNode(1);
        list2.next = new ListNode(3);
        list2.next.next = new ListNode(4);

        ListNode mergedList = mergeTwoLists(list1, list2);

        printList(mergedList);
    }

    public static ListNode mergeTwoLists(ListNode node1, ListNode node2) {
        ListNode node3 = new ListNode();
        ListNode pointer = node3; //the reason we have this instead of just using node3 directly is
        // because we need node3 to point to the head so we can eventurally return it

        while (node1 != null && node2 != null) {
            if (node1.val <= node2.val) {
                pointer.next = node1;
                node1 = node1.next;
            } else {
                pointer.next = node2;
                node2 = node2.next;
            }
            pointer = pointer.next; //advancing the pointer, otherwise we'd still be in the same pointer node and keep replacing pointer.next.
        }

        if (node1 != null) {
            pointer.next = node1; //this actually assigns ALL of the remaining nodes,
            // remember, because node1.next points to the rest of the nodes in its list
        } else {
            pointer.next = node2;
        }

        return node3.next;
    }

    public static void printList(ListNode node) {
        while (node != null) {
            System.out.println(node.val);
            node = node.next;
        }
    }
}


class ListNode {
    int val;
    ListNode next;

    ListNode() {}

    ListNode(int val) {
        this.val = val;
    }

    ListNode(int val, ListNode next) {
        this.val = val;
        this.next = next;
    }
}
```