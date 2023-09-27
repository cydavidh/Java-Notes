package n28_equals_ArrayList_contains;

public class Book {
    private String name;
    private String content;
    private int published;

    public Book(String name, int published, String content) {
        this.name = name;
        this.published = published;
        this.content = content;
    }

    @Override
    public boolean equals(Object comparedObject) {
        if (this == comparedObject)
            return true; // compare the references

        if (!(comparedObject instanceof Book))
            return false; // compare the types

        Book comparedBook = (Book) comparedObject; // cast the object to a Book object

        if (this.name.equals(comparedBook.name) &&
                this.published == comparedBook.published &&
                this.content.equals(comparedBook.content)) {
            return true; // compare the values
        }

        return false;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPublished() {
        return this.published;
    }

    public void setPublished(int published) {
        this.published = published;
    }

    public String getContent() {
        return this.content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String toString() {
        return "Name: " + this.name + " (" + this.published + ")\n"
                + "Content: " + this.content;
    }

}
