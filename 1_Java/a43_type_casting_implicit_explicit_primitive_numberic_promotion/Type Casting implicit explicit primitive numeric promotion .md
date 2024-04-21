# implicit: automatic, small to big

byte
short
int   <---- char
long
float
double


=====================================================================


# explicit: big to small
long to int
```java
long x = 100_000_000_000_000L; // 100000000000000
int n = (int) x;               // 276447232
```
will compile but result is truncated: type overflow

int to short
```java
int largeInt = 32768; // This is 1 more than the maximum value a short can represent
short resultShort = (short) largeInt; // result will be -32767, negative because of binary sign bit. Messy stuff.
```
will compile, but result is messed up.