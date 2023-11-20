```java

# normal

a // match 'a'
a+ // 1 or more occurrences: 'a', 'aa', 'aaa', etc., but not an empty string.
a* // 0 or more occurrences: 'a', 'aa', 'aaa', etc., or an empty string
a? // 0 or 1 occurrence: 'a' or an empty string, but not 'aa' or 'aaa'.
a{4} // 'aaaa', but not 'baaaab'
a{2,4} //  match 'aa', 'aaa', or 'aaaa', but not 'a' or 'aaaaa'.
a{2,} //  match 'aa', 'aaa', 'aaaa', etc., but not 'a'.

# parenthesis very intuitive

abc or (abc) // match 'abc', same as a.
(abc)+ // match 'abc', 'abcabc', 'abcabcabc', etc.
(abc)* // match 'abc', 'abcabc', 'abcabcabc', etc., or an empty string
(abc)? // match 'abc' or an empty string
(abc|def)// match 'abc' or 'def'
a+bc or (a+bc) // match 'abc', 'aabc', 'aaabc', etc., but not 'bc' or 'abbc'.
a*bc or (a*bc) // match 'abc', 'aabc', 'aaabc', etc., or 'bc', 'bbc', 'bbbc', etc.
a?bc or (a?bc) // match 'abc' or 'bc', but not 'aabc' or 'abbc'.

# bracket is for single characters

(a|b|c) or [abc] // match 'a', 'b', or 'c'
[abc]+ // match 'a', 'b', 'c', 'ab', 'abc', 'bc', 'ac', 'aba', 'abab', etc.
[abc]* // match 'a', 'b', 'c', 'ab', 'abc', 'bc', 'ac', 'aba', 'abab', etc., or an empty string
[abc]? // match 'a', 'b', 'c', or an empty string

[a+bc] // match 'a', 'b', 'c', or '+'.
[a*bc] // match 'a', 'b', 'c', or '*'.
[a?bc] // match 'a', 'b', 'c', or '?'.
[^abc] // match any character except 'a', 'b', or 'c'.

# only use hyphen inside brackets
[a-z] // match any lowercase letter
[A-Z] // match any uppercase letter
[0-9] // match any digit

. // This symbol matches any single character except newline characters. For example, a.b would match 'acb', 'aeb', 'a1b', etc.
^ // This symbol matches the start of a line. For example, ^a would match any line that starts with 'a'.
$ // This symbol matches the end of a line. For example, a$ would match any line that ends with 'a'.
\d // This matches any digit (equivalent to [0-9]). For example, \d\d would match '12', '99', etc.
\D // This matches any non-digit character (equivalent to [^0-9]).
\w // This matches any word character (equivalent to [a-zA-Z0-9_]). For example, \w\w would match 'a1', 'b2', etc.
\W // This matches any non-word character (equivalent to [^a-zA-Z0-9_]).
\s // This matches any whitespace character (spaces, tabs, line breaks).
\S // This matches any non-whitespace character.
```