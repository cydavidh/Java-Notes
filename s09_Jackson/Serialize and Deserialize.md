# Serialization of Java records
**writeValueAsString**
```java
record Person(String name, int age) {}

ObjectMapper objectMapper = new ObjectMapper();
Person person = new Person("Alice", 30);
String json = objectMapper.writeValueAsString(person);
```

# Deserialization of Java records
**readValue**
```java
String json = "{\"name\":\"Bob\",\"age\":30}";
Person person = objectMapper.readValue(json, Person.class);
```

=============================================================================================================================================================
# Serialization of Lists of objects
```java
List<Post> posts = List.of(
        new Post(1, new Date(), "Content1", 10, Arrays.asList("Comment1", "Comment2")),
        new Post(2, new Date(), "Content2", 42, Arrays.asList("Comment3", "Comment4"))
);
String postsJson = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(posts);
System.out.println(postsJson);
```
[ {
  "likes" : 10,
  "comments" : [ "Comment1", "Comment2" ],
  "createdDate" : 1697894696259,
  "content" : "Content1",
  "id" : 1
}, {
  "likes" : 42,
  "comments" : [ "Comment3", "Comment4" ],
  "createdDate" : 1697894696259,
  "content" : "Content2",
  "id" : 2
} ]

# Deserialization of Lists of objects
```java
List<Post> deserializedPosts = objectMapper.readValue(postsJson, List.class);
```

=============================================================================================================================================================
