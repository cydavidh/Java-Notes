package cydavidh.springdemo.p04jacksonandserialization;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;
import java.util.List;

//        put this in Application main method.
//        String inputJson = "{\"id\":1,\"createdDate\":1654027200000,\"content\":\"I learned how to use jackson!\",\"likes\":10,\"comments\":[\"Well done!\",\"Great job!\"]}\n";
//
//        ObjectMapper objectMapper = new ObjectMapper();
//        Post post = objectMapper.readValue(inputJson, Post.class);
//        System.out.println(post);
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


    public int getId() {
        return id;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public String getContent() {
        return content;
    }

    public int getLikes() {
        return likes;
    }

    public List<String> getComments() {
        return comments;
    }

    public String toString() {
        return "Post{" +
                "id=" + id +
                ", createdDate=" + createdDate +
                ", content='" + content + '\'' +
                ", likes=" + likes +
                ", comments=" + comments +
                '}';
    }

// getters, setters
}