// MovieBST.java
package com.example.msd.treenode;

import com.example.msd.entity.Movie;

import java.util.LinkedList;
import java.util.List;

public class MovieBST {
    private MovieTreeNode root;

    public void insert(Movie movie) {
        if (movie.getImdb() == null) return;
        root = insertRec(root, movie);
    }

    private MovieTreeNode insertRec(MovieTreeNode node, Movie movie) {
        if (node == null) return new MovieTreeNode(movie, null, null);

        if (movie.getImdb() < node.getMovie().getImdb()) {
            node.setLeft(insertRec(node.getLeft(), movie));
        } else {
            node.setRight(insertRec(node.getRight(), movie));
        }

        return node;
    }

    public List<Movie> inOrderDesc() {
        List<Movie> result = new LinkedList<>();
        inOrderDescRec(root, result);
        return result;
    }

    private void inOrderDescRec(MovieTreeNode node, List<Movie> result) {
        if (node != null) {
            inOrderDescRec(node.getRight(), result);
            result.add(node.getMovie());
            inOrderDescRec(node.getLeft(), result);
        }
    }
    
    
    public List<Movie> inOrderAsc() {
        List<Movie> result = new LinkedList<>();
        inOrderAscRec(root, result);
        return result;
    }

    private void inOrderAscRec(MovieTreeNode node, List<Movie> result) {
        if (node != null) {
            inOrderAscRec(node.getLeft(), result);
            result.add(node.getMovie());
            inOrderAscRec(node.getRight(), result);
        }
    }

}
