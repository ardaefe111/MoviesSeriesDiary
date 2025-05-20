package com.example.msd.service;

import com.example.msd.entity.Comment;
import com.example.msd.entity.Rating;
import com.example.msd.entity.User;

import java.util.List;

public interface UserService {

    String saveUser(User user, String id) throws Exception;

    User getUserById(String id) throws Exception;

    List<User> getAllUsers() throws Exception;

    String deleteUser(String id) throws Exception;

    // Film ve dizi listelerine ekleme
    String addToAlreadyWatchedMovie(String userId, String movieId) throws Exception;
    String addToAlreadyWatchedSeries(String userId, String seriesId) throws Exception;

    String addToWatchLaterMovie(String userId, String movieId) throws Exception;
    String addToWatchLaterSeries(String userId, String seriesId) throws Exception;
    
    



   
}
