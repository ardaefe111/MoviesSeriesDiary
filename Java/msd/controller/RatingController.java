package com.example.msd.controller;

import com.example.msd.entity.Rating;
import com.example.msd.service.RatingService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/ratings")
@RequiredArgsConstructor
public class RatingController {

    private final RatingService ratingService;

    @PostMapping("/add")
    public ResponseEntity<String> addRating(@RequestBody Rating rating) {
        try {
            String result = ratingService.addRating(rating);
            return ResponseEntity.ok(result);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().body("Hata oluştu: " + e.getMessage());
        }
    }

    @GetMapping("/list/{targetId}")
    public ResponseEntity<List<Rating>> getRatingsByTargetId(@PathVariable String targetId) {
        try {
            List<Rating> ratings = ratingService.getRatingsByTargetId(targetId);
            return ResponseEntity.ok(ratings);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/list/{targetId}/average")
    public ResponseEntity<Double> getAverageRating(@PathVariable String targetId) {
        try {
            Double avg = ratingService.calculateAverageRating(targetId);
            if (avg == null) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(avg);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Rating>> getRatingsByUserId(@PathVariable String userId) {
        try {
            List<Rating> ratings = ratingService.getRatingsByUserId(userId);
            return ResponseEntity.ok(ratings);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/list/{targetId}/sorted-by-date")
    public ResponseEntity<List<Rating>> getRatingsByTargetIdSortedByDate(@PathVariable String targetId) {
        try {
            List<Rating> sorted = ratingService.getRatingsByTargetIdSortedByDate(targetId);
            return ResponseEntity.ok(sorted);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .build();
        }
    }
    
    @GetMapping("/list/{targetId}/filter-by-score")
    public ResponseEntity<Map<String,Object>> getRatingsFilteredByScoreWithCount(
            @PathVariable String targetId,
            @RequestParam(required = false) Double minScore,
            @RequestParam(required = false) Double maxScore) {
        try {
            if (minScore == null)  minScore = Double.NEGATIVE_INFINITY;
            if (maxScore == null)  maxScore = Double.POSITIVE_INFINITY;

            // Filtrelenmiş listeyi al
            List<Rating> filtered = ratingService
                .getRatingsFilteredByScore(targetId, minScore, maxScore);

            // Hem listeyi hem count'u paketle
            Map<String,Object> resp = new HashMap<>();
            resp.put("ratings", filtered);
            resp.put("count",   filtered.size());

            return ResponseEntity.ok(resp);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    

}



