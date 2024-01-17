https://stackoverflow.com/questions/4167304/why-should-casting-be-avoided


Casting is bad because if you want a particular type, then you shold define it to be that type to start with.
Some reason to do casting: implement equals method.
But anytime you cast, you should think about redesigning code so correct type is used throughout.

Even seemingly innocuous conversions like integer and floating point.
Integers should really be used for "counted" types of things and floating point for "measured" kinds of things. 
Otherwise you get "the average American family has 1.8 children."