package com.example.msd.treenode;

import com.example.msd.entity.Movie;

import java.util.LinkedList;
import java.util.List;

public class MovieBSTByCount {
    private MovieTreeNode root;

    public void insert(Movie movie) {
        if (movie.getImdbCount() == null) return;
        root = insertRec(root, movie);
    }

    private Long parseImdbCount(String countStr) {
        try {
            return Long.parseLong(countStr.replaceAll(",", "").trim());
        } catch (Exception e) {
            return null;
        }
    }

    private MovieTreeNode insertRec(MovieTreeNode node, Movie movie) {
        Long movieCount = parseImdbCount(movie.getImdbCount());
        if (movieCount == null) return node;

        if (node == null) return new MovieTreeNode(movie, null, null);

        Long nodeCount = parseImdbCount(node.getMovie().getImdbCount());
        if (nodeCount == null || movieCount < nodeCount) {
            node.setLeft(insertRec(node.getLeft(), movie));
        } else {
            node.setRight(insertRec(node.getRight(), movie));
        }

        return node;
    }

    public List<Movie> inOrderAsc() {
        List<Movie> result = new LinkedList<>();
        inOrderAscRec(root, result);
        return result;
    }

    public List<Movie> inOrderDesc() {
        List<Movie> result = new LinkedList<>();
        inOrderDescRec(root, result);
        return result;
    }

    private void inOrderAscRec(MovieTreeNode node, List<Movie> result) {
        if (node != null) {
            inOrderAscRec(node.getLeft(), result);
            result.add(node.getMovie());
            inOrderAscRec(node.getRight(), result);
        }
    }

    private void inOrderDescRec(MovieTreeNode node, List<Movie> result) {
        if (node != null) {
            inOrderDescRec(node.getRight(), result);
            result.add(node.getMovie());
            inOrderDescRec(node.getLeft(), result);
        }
    }
}
