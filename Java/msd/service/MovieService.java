package com.example.msd.service;

import com.example.msd.entity.Movie;

import java.util.List;
import java.util.concurrent.ExecutionException;

public interface MovieService {
    String saveMovie(Movie movie, String id) throws ExecutionException, InterruptedException;
    Movie getMovieById(String id) throws ExecutionException, InterruptedException;
    List<Movie> getAllMovies() throws ExecutionException, InterruptedException;
    String deleteMovie(String id) throws ExecutionException, InterruptedException;
    List<Movie> getMoviesSortedByImdbDesc() throws ExecutionException, InterruptedException;
    List<Movie> getMoviesSortedByImdbAsc() throws ExecutionException, InterruptedException;
    List<Movie> getAllMoviesSortedByImdbCountAsc() throws Exception;
    List<Movie> getAllMoviesSortedByImdbCountDesc() throws Exception;
    List<Movie> getAllMoviesSortedByReleaseYearAsc() throws Exception; 
    List<Movie> getAllMoviesSortedByReleaseYearDesc() throws Exception;
    List<Movie> getAllMoviesSortedByRuntimeAsc() throws Exception;
    List<Movie> getAllMoviesSortedByRuntimeDesc() throws Exception;

    
}
