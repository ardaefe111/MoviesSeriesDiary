package com.example.msd.treenode;

import com.example.msd.entity.Series;

import java.util.ArrayList;
import java.util.List;

public class SeriesBSTByReleaseYear {
    private SeriesTreeNode root;

    public void insert(Series series) {
        root = insertRecursive(root, series);
    }

    private SeriesTreeNode insertRecursive(SeriesTreeNode node, Series series) {
        if (node == null) {
            return new SeriesTreeNode(series, null, null);
        }

        if (series.getReleaseYear() < node.getSeries().getReleaseYear()) {
            node.setLeft(insertRecursive(node.getLeft(), series));
        } else {
            node.setRight(insertRecursive(node.getRight(), series));
        }

        return node;
    }

    public List<Series> inOrderAsc() {
        List<Series> result = new ArrayList<>();
        traverseInOrderAsc(root, result);
        return result;
    }

    public List<Series> inOrderDesc() {
        List<Series> result = new ArrayList<>();
        traverseInOrderDesc(root, result);
        return result;
    }

    private void traverseInOrderAsc(SeriesTreeNode node, List<Series> list) {
        if (node != null) {
            traverseInOrderAsc(node.getLeft(), list);
            list.add(node.getSeries());
            traverseInOrderAsc(node.getRight(), list);
        }
    }

    private void traverseInOrderDesc(SeriesTreeNode node, List<Series> list) {
        if (node != null) {
            traverseInOrderDesc(node.getRight(), list);
            list.add(node.getSeries());
            traverseInOrderDesc(node.getLeft(), list);
        }
    }
}
