We have a box of packables.


Box box1 = new Box(10);
Box box2 = new Box(100);
box2.add(box1);

1st problem.
Box has an arraylist of items each with weight.
Bigger box add smaller box.
If we have an instance variable to store box weight, then we would have problem with box2 weight (won't be updated like box1) when we add item into box1.
so we have method weight() to calculate weight each time instead.


2nd problem.
When you put a box in itself.
box2.add(box2);
Runs fine, except when it tries to get weight, it will calculate the weight of box2, which includes box2 so you need to calculate weight of second box2, which includes third box2, which includes fourth box2.
you get stackoverflow error.