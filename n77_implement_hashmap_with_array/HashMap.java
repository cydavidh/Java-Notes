package n77_implement_hashmap_with_array;

public class HashMap<K, V> {
    private List<Pair<K, V>>[] arrayOfListsOfPairs;
    private int amountOfPairsAdded;

    public HashMap() {
        this.amountOfPairsAdded = 0;
        this.arrayOfListsOfPairs = (List<Pair<K, V>>[]) new List[32];
    }


    public void add(K key, V value) {
        List<Pair<K, V>> tempList = getListInsideArrayWithKey(key);
        int i = getIndexInsideListWithListAndKey(tempList, key);
        if (i == -1) {
            tempList.add(new Pair<K, V>(key, value)); // new Pair<>(key, value)
            amountOfPairsAdded++;
        } else {
            tempList.getValueOfIndex(i).setValue(null);
        }
    }

    private List<Pair<K, V>> getListInsideArrayWithKey(K key) {
        int hashCode = Math.abs(key.hashCode() % this.arrayOfListsOfPairs.length);
        if (arrayOfListsOfPairs[hashCode] == null) {
            arrayOfListsOfPairs[hashCode] = new List<Pair<K, V>>();
        }
        return arrayOfListsOfPairs[hashCode];
    }

    private int getIndexInsideListWithListAndKey(List<Pair<K, V>> list, K key) {
        for (int i = 0; i < list.size(); i++) {
            if (list.getValueOfIndex(i).getKey().equals(key)) {
                return i;
            }
        }
        return -1;
    }

    public V get(K key) {
        List<Pair<K, V>> tempList = getListInsideArrayWithKey(key); // the particular List of Pairs that contains the pair we're looking for
        int indexOfKeyInsideList = getIndexInsideListWithListAndKey(tempList, key); // the index of the pair inside this list
        if (indexOfKeyInsideList == -1) {
            return null;
        }
        Pair<K, V> tempPair = tempList.getValueOfIndex(indexOfKeyInsideList);
        return tempPair.getValue(); // list.getValue to get the pair, and then getValue to get pair's value.
    }

    private void grow() {
        List<Pair<K, V>>[] newArray = new List[arrayOfListsOfPairs.length * 2];
        for (int i = 0; i < arrayOfListsOfPairs.length; i++) {
            copy(newArray, i);
        }
    }

    private void copy(List<Pair<K, V>>[] newArray, int indexOfElementFromOldArrayToBeCopied) {
        for (int i = 0; i < arrayOfListsOfPairs[indexOfElementFromOldArrayToBeCopied].size(); i++) {
            Pair<K, V> tempPair = arrayOfListsOfPairs[indexOfElementFromOldArrayToBeCopied].getValueOfIndex(i);
            int hashCode = Math.abs(tempPair.getKey().hashCode() % newArray.length);
            if (newArray[hashCode] == null) {
                newArray[hashCode] = new List<Pair<K, V>>();
            }
            newArray[hashCode].add(tempPair);
        }
        this.arrayOfListsOfPairs = newArray;
    }

    public V remove(K key) {
        List<Pair<K, V>> tempList = getListInsideArrayWithKey(key);
        if (tempList.size() == 0) {
            return null;
        }
        // for (int i = 0; i < tempList.size(); i++) {
        // Pair<K, V> tempPair = tempList.getValueOfIndex(i);
        // if (tempPair.getKey() == key) {
        // tempList.remove(tempPair);
        // return tempPair.getValue();
        // }
        // }
        int index = getIndexInsideListWithListAndKey(tempList, key);
        if (index < 0) {
            return null;
        }
        Pair<K, V> tempPair = tempList.getValueOfIndex(index);
        tempList.remove(tempPair);
        return tempPair.getValue();

    }

    public String toString() {
        String tempString = new String();
        for (int i = 0; i < arrayOfListsOfPairs.length; i++) {
            if (arrayOfListsOfPairs[i] == null) {
                continue;
            }
            if (arrayOfListsOfPairs[i].size() > 0) {
                for (int j = 0; j < arrayOfListsOfPairs[i].size(); j++) {
                    Pair<K, V> tempPair = arrayOfListsOfPairs[i].getValueOfIndex(j);
                    tempString += String.format(", (%s, %s)", tempPair.getKey().toString(), tempPair.getValue());
                }
            }
        }
        if (!tempString.isEmpty()) {
            tempString = tempString.substring(2);
        }
        return tempString;
    }
}
