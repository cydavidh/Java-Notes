Serialize Java Objects to JSON.
Deserialize JSON into Java Objects.

Gradle
```
implementation 'com.fasterxml.jackson.core:jackson-databind:2.15.3'
```

=============================================================================================================================================================

```java
public class Post {
    private int id;
    private Date createdDate;
    private String content;
    private int likes;
    private List<String> comments;

//  contructor, getters, setters
}
```

```java
// Step 1
Post post = new Post(1, new Date(), "I learned how to use jackson!", 10, Arrays.asList("Well done!", "Great job!"));

// Step 2
ObjectMapper objectMapper = new ObjectMapper();

// Step 3
String postAsString = objectMapper.writeValueAsString(post);

System.out.println(postAsString);
```

{"id":1,"createdDate":1655112861424,"content":"I learned how to use jackson!","likes":10,"comments":["Well done!","Great job!"]}

=============================================================================================================================================================
```java
String postAsString = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(post);
```

{
  "id" : 1,
  "createdDate" : 1654027200000,
  "content" : "I learned how to use jackson!",
  "likes" : 10,
  "comments" : [ "Well done!", "Great job!" ]
}


=============================================================================================================================================================
# @JsonProperty to change name
```java
public class Post {
    private int id;

    @JsonProperty("postedAt")
    private Date createdDate;

    private String content;
    private int likes;
    private List<String> comments;
}
```

{
  "id" : 1,
  "content" : "I learned how to use jackson!",
  "likes" : 10,
  "comments" : [ "Well done!", "Great job!" ],
  **"postedAt" : 1654027200000 // here**
}

=============================================================================================================================================================
# @JsonProperty to denote getter/setter applied to the json property

```java
public class Post {
    private int id;
    private Date createdDate;
    private String content;
    private int likes;
    private List<String> comments;


    @JsonProperty("createdDate")
    public String getReadableCreatedDate() {
        return (new SimpleDateFormat("dd-MM-yyyy")).format(createdDate);
    }

// contructor, getters, setters
}
```

{
  "id" : 1,
  **"createdDate" : "01-06-2022",**
  "content" : "I learned how to use jackson!",
  "likes" : 10,
  "comments" : [ "Well done!", "Great job!" ]
}
=============================================================================================================================================================
# @JsonIgnore to ignore field

```java
public class Post {
    @JsonIgnore
    private int id;
    private Date createdDate;
    private String content;
    private int likes;
    private List<String> comments;
}
```

{
  "content" : "I learned how to use jackson!",
  "likes" : 10,
  "comments" : [ "Well done!", "Great job!" ],
  "createdDate" : 1654027200000
}

=============================================================================================================================================================
# JsonPropertyOrder

```java
@JsonPropertyOrder({
            "likes",
            "comments",
            "createdDate", // here you can also use 'postedAt'
            "content",
    })
public class Post {
    @JsonIgnore
    private int id;

    @JsonProperty("postedAt")
    private Date createdDate;

    private String content;
    private int likes;
    private List<String> comments;
}
```

{
  "likes" : 10,
  "comments" : [ "Well done!", "Great job!" ],
  "postedAt" : 1654027200000,
  "content" : "I learned how to use jackson!"
}

=============================================================================================================================================================
# Deserialize from JSON into Java Object

```java
String inputJson = "{\"id\":1,\"createdDate\":1654027200000,\"content\":\"I learned how to use jackson!\",\"likes\":10,\"comments\":[\"Well done!\",\"Great job!\"]}\n";

ObjectMapper objectMapper = new ObjectMapper();
Post post = objectMapper.readValue(inputJson, Post.class);
```

Method 1: Default Constructor
```java 
public class Post {
    private int id;
    private Date createdDate;
    private String content;
    private int likes;
    private List<String> comments;

    public Post() {
    }

// getters, setters
}
```
Method 2: Custom Creator Constructor
```java
public class Post {
    private final int id;
    private final Date createdDate;
    private String content;
    private int likes;
    private List<String> comments;

    @JsonCreator
    public Post(
            @JsonProperty("id") int id,
            @JsonProperty("createdDate") Date createdDate,
            @JsonProperty("content") String content,
            @JsonProperty("likes") int likes,
            @JsonProperty("comments") List<String> comments) {
        this.id = id;
        this.createdDate = createdDate;
        this.content = content;
        this.likes = likes;
        this.comments = comments;
    }

    public Post() {}
// getters
}
```

<!-- public Post() {} will create an error with the final keywords for the id and the date.

The error caused by the public post() {} constructor in your Post class is likely due to a conflict with the final fields id and createdDate. In Java, final fields must be initialized when the object is created, and this is typically done in the constructor. However, your empty constructor public post() {} does not initialize these final fields, which is required by Java for any final variable.

Since id and createdDate are final, they must be assigned a value in every constructor of the class. The empty constructor doesn't provide values for these fields, leading to a compilation error. To fix this, you would need to either remove the final keyword from these fields, provide default values for them in the empty constructor, or remove the empty constructor if it's not needed. -->

=============================================================================================================================================================
