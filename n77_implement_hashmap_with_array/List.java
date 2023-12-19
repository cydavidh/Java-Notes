package n77_implement_hashmap_with_array;

import java.util.Arrays;

public class List<T> {
    private T[] values;
    private int firstFreeIndex;

    public List() {
        this.values = (T[]) new Object[10];
    }

    // public void grow1() {
    // T[] temp = (T[]) new Object[firstFreeIndex + firstFreeIndex / 2];
    // for (int i = 0; i < firstFreeIndex; i++) {
    // temp[i] = values[i];
    // }
    // this.values = temp;
    // }

    private void grow2() {
        this.values = Arrays.copyOf(this.values, this.values.length + this.values.length / 2);
    }

    public void add(T value) {
        if (firstFreeIndex == values.length) {
            grow2();
        }
        this.values[firstFreeIndex] = value;
        firstFreeIndex++;
    }

    public String toString() {
        return Arrays.toString(this.values);
    }

    public boolean contains(T value) {
        for (int i = 0; i < firstFreeIndex; i++) {
            if (this.values[i].equals(value)) {
                return true;
            }
        }
        return false;
    }

    public int getIndexOfValue(T value) {
        for (int i = 0; i < firstFreeIndex; i++) {
            if (this.values[i].equals(value)) {
                return i;
            }
        }
        return -1;
    }

    public void moveLeft(int fromIndex) {
        for (int i = fromIndex; i < firstFreeIndex; i++) {
            this.values[i] = this.values[i + 1];
        }
        firstFreeIndex--;
    }

    public void remove(T value) {
        int i = getIndexOfValue(value);
        if (i > -1) {
            moveLeft(i);
        }
    }

    public T getValueOfIndex(int index) {
        return this.values[index];
    }

    public int size() {
        return firstFreeIndex;
    }

}
