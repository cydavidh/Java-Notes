https://leetcode.com/problems/valid-palindrome/

this question is more like a java question than a dsa question.

// Instance methods
s.toCharArray()
sb.reverse()
sb.toString()

// Static methods
Character.isLetterOrDigit(char)
Character.toLowerCase(char)

// Constructor
new StringBuilder()

```java
class Sandbox {
    public static void main(String[] args) {
        System.out.println(isPalindrome("abbbae"));
    }

    static boolean isPalindrome(String s) {
        StringBuilder stringBuilder = new StringBuilder();
        for (char a : s.toCharArray()) {
            if (Character.isLetterOrDigit(a)) {
                stringBuilder.append(Character.toLowerCase(a));
            }
        }
        String cleanedString = stringBuilder.toString();
        return cleanedString.equals(stringBuilder.reverse().toString());
    }
}
```