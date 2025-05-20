// SeriesBST.java
package com.example.msd.treenode;

import com.example.msd.entity.Series;

import java.util.LinkedList;
import java.util.List;

public class SeriesBST {
    private SeriesTreeNode root;

    public void insert(Series series) {
        if (series.getImdb() == null) return;
        root = insertRec(root, series);
    }

    private SeriesTreeNode insertRec(SeriesTreeNode node, Series series) {
        if (node == null) return new SeriesTreeNode(series, null, null);

        if (series.getImdb() < node.getSeries().getImdb()) {
            node.setLeft(insertRec(node.getLeft(), series));
        } else {
            node.setRight(insertRec(node.getRight(), series));
        }

        return node;
    }

    public List<Series> inOrderAsc() {
        List<Series> result = new LinkedList<>();
        inOrderAscRec(root, result);
        return result;
    }

    public List<Series> inOrderDesc() {
        List<Series> result = new LinkedList<>();
        inOrderDescRec(root, result);
        return result;
    }

    private void inOrderAscRec(SeriesTreeNode node, List<Series> result) {
        if (node != null) {
            inOrderAscRec(node.getLeft(), result);
            result.add(node.getSeries());
            inOrderAscRec(node.getRight(), result);
        }
    }

    private void inOrderDescRec(SeriesTreeNode node, List<Series> result) {
        if (node != null) {
            inOrderDescRec(node.getRight(), result);
            result.add(node.getSeries());
            inOrderDescRec(node.getLeft(), result);
        }
    }
}
