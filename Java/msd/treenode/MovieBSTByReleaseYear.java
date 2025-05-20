package com.example.msd.treenode;

import com.example.msd.entity.Movie;

import java.util.ArrayList;
import java.util.List;

public class MovieBSTByReleaseYear {
    private MovieTreeNode root;

    public void insert(Movie movie) {
        root = insertRecursive(root, movie);
    }

    private MovieTreeNode insertRecursive(MovieTreeNode node, Movie movie) {
        if (node == null) {
            return new MovieTreeNode(movie, null, null);
        }

        if (movie.getReleaseYear() < node.getMovie().getReleaseYear()) {
            node.setLeft(insertRecursive(node.getLeft(), movie));
        } else {
            node.setRight(insertRecursive(node.getRight(), movie));
        }

        return node;
    }

    public List<Movie> inOrderAsc() {
        List<Movie> result = new ArrayList<>();
        traverseInOrderAsc(root, result);
        return result;
    }

    public List<Movie> inOrderDesc() {
        List<Movie> result = new ArrayList<>();
        traverseInOrderDesc(root, result);
        return result;
    }

    private void traverseInOrderAsc(MovieTreeNode node, List<Movie> list) {
        if (node != null) {
            traverseInOrderAsc(node.getLeft(), list);
            list.add(node.getMovie());
            traverseInOrderAsc(node.getRight(), list);
        }
    }

    private void traverseInOrderDesc(MovieTreeNode node, List<Movie> list) {
        if (node != null) {
            traverseInOrderDesc(node.getRight(), list);
            list.add(node.getMovie());
            traverseInOrderDesc(node.getLeft(), list);
        }
    }
}
