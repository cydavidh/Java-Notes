Yes, in Java, there are default types assumed for literal values of different primitive types. These defaults are based on the type of literal (integer, floating-point, etc.) and sometimes on the suffix used. Understanding these defaults is essential for correctly declaring and initializing variables without unnecessary casting or to avoid compilation errors. Here are the rules for the other primitive types:

### Integer Literals
- **byte, short, int, long:**
  - By default, any whole number literal (without a decimal point) is considered an `int` type. This means that even if you're assigning a literal to a `byte` or `short` variable, as long as the number is within the valid range for the type, it's treated as an `int` that's being implicitly cast to a `byte` or `short`.
  - For a literal to be considered a `long`, you must append an `L` or `l` suffix (e.g., `123L`). However, using `l` is discouraged because it can be easily confused with the digit `1`.

```java
byte b = 100; // Implicitly cast from int to byte
short s = 1000; // Implicitly cast from int to short
int i = 100000; // No suffix needed, defaults to int
long l = 100000L; // 'L' suffix indicates a long literal
```

### Floating-point Literals
- **float, double:**
  - Any number with a decimal point or in exponential notation is considered a `double` by default. To explicitly declare a `float` literal, you must append an `F` or `f` suffix.
  - For `double`, you can optionally append a `D` or `d` suffix, but it's not necessary since floating-point literals are `double` by default.

```java
float f = 12.34f; // 'F' suffix indicates a float literal
double d = 12.34; // No suffix needed, defaults to double
double e = 1234e-2; // Exponential notation, also defaults to double
```

### Character and Boolean Literals
- **char:**
  - Character literals are enclosed in single quotes (e.g., `'a'`).
- **boolean:**
  - Boolean literals are simply `true` or `false` with no suffixes or special notation needed.

```java
char c = 'a'; // Character literal
boolean bool = true; // Boolean literal
```

Understanding these rules helps in correctly initializing primitive variables and avoiding implicit conversions that might not be immediately obvious, ensuring your Java code is both clear and efficient.