https://leetcode.com/problems/valid-parentheses/description/

```
Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:

Open brackets must be closed by the same type of brackets.
Open brackets must be closed in the correct order.
Every close bracket has a corresponding open bracket of the same type.
 

Example 1:

Input: s = "()"
Output: true
Example 2:

Input: s = "()[]{}"
Output: true
Example 3:

Input: s = "(]"
Output: false
 

Constraints:

1 <= s.length <= 104
s consists of parentheses only '()[]{}'.
```

/*
1. loop over the string
2. add all opening brackets to the stack
3. if closing bracket, pop, empty? false : keep going, compare? keep going : return false
4. at end, if empty? true : false,
 */


```java
class Solution {
    public boolean isValid(String s) {
        Stack<Character> stack = new Stack<>();
        for (char a : s.toCharArray()) {
            if (a == '{' || a == '[' || a == '(') {
                stack.push(a);
            }
            if (a == '}' || a == ']' || a == ')') {
                if (stack.empty()) {
                    return false;
                }
                int b = stack.pop();
                switch (a) {
                    case '}':
                        if (b != '{') return false;
                        break;
                    case ']':
                        if (b != '[') return false;
                        break;
                    case ')':
                        if (b != '(') return false;
                        break;
                }
            }
        }
        if (stack.empty()) {
            return true;
        } else {
            return false;
        }
    }
}
```

Time complexity:
The time complexity of the solution is O(n), where n is the length of the input string. This is because we traverse the string once and perform constant time operations for each character.

Space complexity:
The space complexity of the solution is O(n), where n is the length of the input string. This is because the worst-case scenario is when all opening brackets are present in the string and the stack will have to store them all.