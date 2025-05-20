package com.example.msd.controller;

import com.example.msd.entity.Movie;
import com.example.msd.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/movies")
public class MovieController {

    private final MovieService movieService;

    @Autowired
    public MovieController(MovieService movieService) {
        this.movieService = movieService;
    }

    // Film kaydetme
    @PostMapping("/add/{id}")
    public ResponseEntity<String> saveMovie(@RequestBody Movie movie, @PathVariable String id) {
        try {
            String response = movieService.saveMovie(movie, id);
            return ResponseEntity.ok(response);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body("Film kaydedilemedi: " + e.getMessage());
        }
    }

    // Film bilgisi alma
    @GetMapping("/get/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable String id) {
        try {
            Movie movie = movieService.getMovieById(id);
            if (movie != null) {
                return ResponseEntity.ok(movie);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    // Tüm filmleri listeleme
    @GetMapping("/get/all")
    public ResponseEntity<List<Movie>> getAllMovies() {
        try {
            List<Movie> movies = movieService.getAllMovies();
            return ResponseEntity.ok(movies);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    // Film silme
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteMovie(@PathVariable String id) {
        try {
            String response = movieService.deleteMovie(id);
            return ResponseEntity.ok(response);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body("Film silinemedi: " + e.getMessage());
        }
    }
    
    
 // IMDb azalan (yüksekten düşüğe)
    @GetMapping("/get/sorted/imdb-desc")
    public ResponseEntity<List<Movie>> getMoviesSortedByImdbDesc() {
        try {
            List<Movie> movies = movieService.getMoviesSortedByImdbDesc();
            return ResponseEntity.ok(movies);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    // IMDb artan (düşükten yükseğe)
    @GetMapping("/get/sorted/imdb-asc")
    public ResponseEntity<List<Movie>> getMoviesSortedByImdbAsc() {
        try {
            List<Movie> movies = movieService.getMoviesSortedByImdbAsc();
            return ResponseEntity.ok(movies);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(500).body(null);
        }
    }
    
    // IMDb Count'a göre artan sıralı liste
    @GetMapping("/get/sorted/imdb-count-asc")
    public ResponseEntity<List<Movie>> getMoviesSortedByImdbCountAsc() {
        try {
            List<Movie> sortedMovies = movieService.getAllMoviesSortedByImdbCountAsc();
            return ResponseEntity.ok(sortedMovies);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // IMDb Count'a göre azalan sıralı liste
    @GetMapping("/get/sorted/imdb-count-desc")
    public ResponseEntity<List<Movie>> getMoviesSortedByImdbCountDesc() {
        try {
            List<Movie> sortedMovies = movieService.getAllMoviesSortedByImdbCountDesc();
            return ResponseEntity.ok(sortedMovies);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/get/sorted/releaseyear-asc")
    public ResponseEntity<List<Movie>> getMoviesByReleaseYearAsc() {
        try {
            return ResponseEntity.ok(movieService.getAllMoviesSortedByReleaseYearAsc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Exception yakalama
        }
    }

    @GetMapping("/get/sorted/releaseyear-desc")
    public ResponseEntity<List<Movie>> getMoviesByReleaseYearDesc() {
        try {
            return ResponseEntity.ok(movieService.getAllMoviesSortedByReleaseYearDesc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/get/sorted/runtime-asc")
    public ResponseEntity<List<Movie>> getMoviesByRuntimeAsc() {
        try {
            return ResponseEntity.ok(movieService.getAllMoviesSortedByRuntimeAsc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/get/sorted/runtime-desc")
    public ResponseEntity<List<Movie>> getMoviesByRuntimeDesc() {
        try {
            return ResponseEntity.ok(movieService.getAllMoviesSortedByRuntimeDesc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    
   
}
