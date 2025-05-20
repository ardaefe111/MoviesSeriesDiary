package com.example.msd.service;

import com.example.msd.entity.Rating;

import java.util.List;
import java.util.concurrent.ExecutionException;

public interface RatingService {
    String addRating(Rating rating) throws ExecutionException, InterruptedException;
    List<Rating> getRatingsByTargetId(String targetId) throws ExecutionException, InterruptedException;
    Double calculateAverageRating(String targetId) throws ExecutionException, InterruptedException;
    List<Rating> getRatingsByUserId(String userId) throws ExecutionException, InterruptedException;
    List<Rating> getRatingsByTargetIdSortedByDate(String targetId) throws ExecutionException, InterruptedException;
    List<Rating> getRatingsFilteredByScore(String targetId, Double minScore, Double maxScore) throws ExecutionException, InterruptedException;
}
