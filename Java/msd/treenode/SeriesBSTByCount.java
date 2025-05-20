package com.example.msd.treenode;

import com.example.msd.entity.Series;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class SeriesBSTByCount {
    private SeriesTreeNode root;

    // IMDb Count String olduğu için kıyaslama öncesi sayıya çevirmemiz gerekiyor
    private final Comparator<Series> comparator = (s1, s2) -> {
        try {
            int count1 = Integer.parseInt(s1.getImdbCount().replaceAll("[^0-9]", ""));
            int count2 = Integer.parseInt(s2.getImdbCount().replaceAll("[^0-9]", ""));
            return Integer.compare(count1, count2);
        } catch (NumberFormatException e) {
            return 0; // Dönüştürme hatası olursa eşit kabul edelim
        }
    };

    public void insert(Series series) {
        root = insertRecursive(root, series);
    }

    private SeriesTreeNode insertRecursive(SeriesTreeNode node, Series series) {
        if (node == null) {
            return new SeriesTreeNode(series, null, null);
        }

        if (comparator.compare(series, node.getSeries()) < 0) {
            node.setLeft(insertRecursive(node.getLeft(), series));
        } else {
            node.setRight(insertRecursive(node.getRight(), series));
        }

        return node;
    }

    public List<Series> inOrderAsc() {
        List<Series> sortedList = new ArrayList<>();
        inOrderAscRecursive(root, sortedList);
        return sortedList;
    }

    private void inOrderAscRecursive(SeriesTreeNode node, List<Series> list) {
        if (node != null) {
            inOrderAscRecursive(node.getLeft(), list);
            list.add(node.getSeries());
            inOrderAscRecursive(node.getRight(), list);
        }
    }

    public List<Series> inOrderDesc() {
        List<Series> sortedList = new ArrayList<>();
        inOrderDescRecursive(root, sortedList);
        return sortedList;
    }

    private void inOrderDescRecursive(SeriesTreeNode node, List<Series> list) {
        if (node != null) {
            inOrderDescRecursive(node.getRight(), list);
            list.add(node.getSeries());
            inOrderDescRecursive(node.getLeft(), list);
        }
    }
}
