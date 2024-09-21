Recursion.
The algorithm is bound to the application stack due to its recursive nature. Meaning, the stack will overflow for large
trees.
Real-world Impact: Rarely an issue for balanced trees or typical use cases.
Otherwise, the recursive solution is clean, efficient and suitable for most practical scenarios.

```java
package cydavidh.sandbox;

import java.util.*;

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;

    TreeNode(int val) {
        this.val = val;
    }

    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Sandbox {
    public static void main(String[] args) {
        TreeNode root1 = createTree(new Integer[]{4, 2, 7, 1, 3, 6, 9}); //Integer[] for empty nodes, since int[] can't have null.
        System.out.println(printTreeLevelOrderTraversal(root1));
        System.out.println(printTreeLevelOrderTraversal(invertTreeRecursion(root1)));

        int depth = 0;
        try {
            while (true) {
                TreeNode root = buildDeepTree(depth);
                invertTreeRecursion(root);
                depth++;
            }
        } catch (StackOverflowError e) {
            System.out.println(e.getMessage());
            System.out.println("stack overflowed at depth: " + depth);
        }
    }

    static TreeNode createTree(Integer[] arr) {
        if (arr == null || arr.length == 0 || arr[0] == null) {
            return null;
        }

        TreeNode root = new TreeNode(arr[0]);
        java.util.Queue<TreeNode> queue = new java.util.LinkedList<>();
        queue.offer(root);

        for (int i = 1; i < arr.length; i += 2) {
            TreeNode current = queue.poll();

            if (arr[i] != null) {
                current.left = new TreeNode(arr[i]);
                queue.offer(current.left);
            }

            if (i + 1 < arr.length && arr[i + 1] != null) {
                current.right = new TreeNode(arr[i + 1]);
                queue.offer(current.right);
            }
        }
        return root;
    }

    static List<Integer> printTreeLevelOrderTraversal(TreeNode root) {
        List<Integer> list1 = new ArrayList<>();
        Queue<TreeNode> queue1 = new LinkedList<>();

        if (root == null) {
            return list1;
        }

        queue1.offer(root);

        while (!queue1.isEmpty()) {
            TreeNode node = queue1.poll();
            list1.add(node.val);
            if (node.left != null) queue1.offer(node.left);
            if (node.right != null) queue1.offer(node.right);
        }

        return list1;
    }

    static TreeNode buildDeepTree(int depth) {
        if (depth == 0) return null;
        TreeNode node = new TreeNode(depth);
        node.left = buildDeepTree(depth - 1);
        return node;
    }

    static TreeNode invertTreeRecursionDFS(TreeNode root) {
        if (root == null) {
            return null;
        }

        TreeNode right = root.right;
        TreeNode left = root.left;

        root.right = invertTreeRecursionDFS(left);
        root.left = invertTreeRecursionDFS(right);

        return root;
    }

    static TreeNode invertTreeIterativeStackDFS(TreeNode root) {
        if (root == null) {
            return null;
        }

        Deque<TreeNode> stack = new ArrayDeque<>();
        stack.push(root);
        while (!stack.isEmpty()) {
            TreeNode node = stack.pop();
            TreeNode tempLeft = node.left;
            node.left = node.right;
            node.right = tempLeft;
            if (node.left != null) {
                stack.push(node.left);
            }
            if (node.right != null) {
                stack.push(node.right);
            }
        }
        return root;
    }

    static TreeNode invertTreeIterativeQueueDFS(TreeNode root) {
        if (root == null) {
            return null;
        }

        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            TreeNode tempLeft = node.left;
            node.left = node.right;
            node.right = tempLeft;
            if (node.left != null) {
                queue.offer(node.left);
            }
            if (node.right != null) {
                queue.offer(node.right);
            }
        }
        return root;
    }
}
```