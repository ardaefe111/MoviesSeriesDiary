package com.example.msd.service.impl;

import com.example.msd.entity.Movie;
import com.example.msd.service.MovieService;
import com.example.msd.treenode.MovieBST;
import com.example.msd.treenode.MovieBSTByCount;
import com.example.msd.treenode.MovieBSTByReleaseYear;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.WriteResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class MovieServiceImpl implements MovieService {

    private final Firestore firestore;

    @Autowired
    public MovieServiceImpl(Firestore firestore) {
        this.firestore = firestore;
    }

    @Override
    public String saveMovie(Movie movie, String id) throws ExecutionException, InterruptedException {
        ApiFuture<WriteResult> result = firestore.collection("movies").document(id).set(movie);
        return "Film kaydedildi: " + result.get().getUpdateTime();
    }

    @Override
    public Movie getMovieById(String id) throws ExecutionException, InterruptedException {
        DocumentSnapshot snapshot = firestore.collection("movies").document(id).get().get();
        return snapshot.exists() ? snapshot.toObject(Movie.class) : null;
    }

    @Override
    public List<Movie> getAllMovies() throws ExecutionException, InterruptedException {
        return firestore.collection("movies").get().get().toObjects(Movie.class);
    }

    @Override
    public String deleteMovie(String id) throws ExecutionException, InterruptedException {
        ApiFuture<WriteResult> result = firestore.collection("movies").document(id).delete();
        return "Film silindi: " + result.get().getUpdateTime();
    }
    
    @Override
    public List<Movie> getMoviesSortedByImdbDesc() throws ExecutionException, InterruptedException {
        List<Movie> movies = getAllMovies(); 
        MovieBST bst = new MovieBST();      
        for (Movie movie : movies) {
            bst.insert(movie);              
        }
        return bst.inOrderDesc();            
    }

    @Override
    public List<Movie> getMoviesSortedByImdbAsc() throws ExecutionException, InterruptedException {
        List<Movie> movies = getAllMovies(); 
        MovieBST bst = new MovieBST();      
        for (Movie movie : movies) {
            bst.insert(movie);              
        }
        return bst.inOrderAsc();
    }
    
    @Override
    public List<Movie> getAllMoviesSortedByImdbCountAsc() throws Exception {
        List<Movie> allMovies = getAllMovies(); // bu senin zaten var olan methodun
        MovieBSTByCount bst = new MovieBSTByCount();
        for (Movie movie : allMovies) {
            bst.insert(movie);
        }
        return bst.inOrderAsc();
    }

    @Override
    public List<Movie> getAllMoviesSortedByImdbCountDesc() throws Exception {
        List<Movie> allMovies = getAllMovies();
        MovieBSTByCount bst = new MovieBSTByCount();
        for (Movie movie : allMovies) {
            bst.insert(movie);
        }
        return bst.inOrderDesc();
    }
    
    @Override
    public List<Movie> getAllMoviesSortedByReleaseYearAsc() throws Exception {
        List<Movie> movies = getAllMovies();  // Exception handling burada yapılacak
        MovieBSTByReleaseYear bst = new MovieBSTByReleaseYear();
        for (Movie movie : movies) {
            bst.insert(movie);  // Eğer insert sırasında bir hata varsa, exception fırlatılacak
        }
        return bst.inOrderAsc();  // BST traversing sırasında hata olabilir
    }

    @Override
    public List<Movie> getAllMoviesSortedByReleaseYearDesc() throws Exception {
        List<Movie> movies = getAllMovies();  // Exception handling burada yapılacak
        MovieBSTByReleaseYear bst = new MovieBSTByReleaseYear();
        for (Movie movie : movies) {
            bst.insert(movie);
        }
        return bst.inOrderDesc();
    }
    
    @Override
    public List<Movie> getAllMoviesSortedByRuntimeAsc() throws Exception {
        List<Movie> allMovies = getAllMovies();
        LinkedList<Movie> movieLinkedList = new LinkedList<>(allMovies);

        movieLinkedList.sort((m1, m2) -> {
            Integer r1 = m1.getRuntime() != null ? m1.getRuntime() : 0;
            Integer r2 = m2.getRuntime() != null ? m2.getRuntime() : 0;
            return r1.compareTo(r2);
        });

        return movieLinkedList;
    }
    
    @Override
    public List<Movie> getAllMoviesSortedByRuntimeDesc() throws Exception {
        List<Movie> allMovies = getAllMovies();
        LinkedList<Movie> movieLinkedList = new LinkedList<>(allMovies);

        movieLinkedList.sort((m1, m2) -> {
            Integer r1 = m1.getRuntime() != null ? m1.getRuntime() : 0;
            Integer r2 = m2.getRuntime() != null ? m2.getRuntime() : 0;
            return r2.compareTo(r1);  // Descending
        });

        return movieLinkedList;
    }




   
    
}
