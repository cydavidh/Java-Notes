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

The variable `myFavBox` is not final; thus, while you cannot alter the contents of the existing `Box<Kitten>`, you can reassign `myFavBox` to refer to a different `Box` instance, such as `Box<Puppy>`.