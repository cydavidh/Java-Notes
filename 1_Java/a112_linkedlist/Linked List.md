import java.util LinkedList
doubly linked list

```java
LinkedList<String> linkedList = new LinkedList<>();

linkedList.add("asdf"); //add at end
//O(1), if singly linked list then O(n), if the list doesn't maintatin a tail pointer
linkedList.add(int index, E element); //insert at specific position
linkedList.addLast("asdf");
linkedList.addFirst("asdf"); //O(1)
linkedList.set(int index, E element); //replace element at index
linkedList.indexOf("asdf"); //return first occurance, or -1
linkedList.peek(); //view head
linkedList.peekLast();
linkedList.poll(); //return and remove head, like stack.pop()
linkedList.pollLast();
linkedList.remove("asdf");
linkedList.getFirst();
linkedList.getLast();


```