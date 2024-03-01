we have a box<?> class with a type parameter/generic type.

Box<Kitten> myFavBox = new Box<>(new Kitten()); //new Kitten() necessary for Box constructor.

contains objects of type kittens in the box.

class Box<?> {
    private final T content; // we make the content of the box immutable.

    public Box(T content) {
        this.content = content;
    }

    public T getContent() {
        return content;
    }
}

Box is immutable, and once created you can't change the contents of it.

But the variable myFavBox is not immutable, so you can reassign it so that it points to the intance of another box like Box<Puppy>.