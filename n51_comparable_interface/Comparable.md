Comparable Interface

```java
public interface Comparable<T> { //T = type
    //  Returns a 
    //  negative integer, zero, or a positive integer 
    //  as this object is 
    //  less than, equal to, or greater 
    //  than the specified object.

    public int compareTo(T o); //T o = Type object
}
```

Object implement Comparable can be .sorted() and Collections.sort();

```java
Member implement Comparable<Member>{
    private age;
    constructor;
    public int compareTo(Member anotherMember) {
        return this.age - anotherMember.age
    }
}

List<Member> members = new ArrayList<>();
members.add(new Member("mikael", 89));
members.add(new Member("matti", 18));
members.add(new Member("ada", 33));

members.stream()
        .sorted()
        .forEach(m -> System.out.println(m)); //18, 33, 89
```

Stream.sorted() sorts stream only
Collections.sort() sorts original
Again, both only work for objects that has implemented Comparable<> and compareTo()

```java 
Collections.sort(member);
members.stream().forEach(m -> System.out.println(m));
```

Object can implement Comparable in lambda

```java
Member {
    private age;
    constructor;
    public getAge() {return this.age};
}

List<Member> members = new ArrayList<>();
members.stream()
        .sorted((mem1, mem2) -> {
            return mem1.getAge() - mem2.getAge();
        })
        .forEach(m -> System.out.println(m)); //18, 33, 89
```

```java
Collections.sort(members, (mem1, mem2) -> mem1.getAge() - mem2.getAge());
```

Object (like String) inside the Object implementing Comparable, as parameter for the sorted method, 
can also use its own comparedTo method

```java
.sorted((p1, p2) -> {
    return p1.getName().compareTo(p2.getName());
})
```


