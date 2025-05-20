package com.example.msd.controller;

import com.example.msd.entity.Comment;
import com.example.msd.entity.Rating;
import com.example.msd.entity.User;
import com.example.msd.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/add/{id}")
    public String saveUser(@RequestBody User user, @PathVariable String id) throws Exception {
        return userService.saveUser(user, id);
    }

    @GetMapping("/get/{id}")
    public User getUserById(@PathVariable String id) throws Exception {
        return userService.getUserById(id);
    }

    @GetMapping("/get/all")
    public List<User> getAllUsers() throws Exception {
        return userService.getAllUsers();
    }

    @DeleteMapping("/delete/{id}")
    public String deleteUser(@PathVariable String id) throws Exception {
        return userService.deleteUser(id);
    }

    // İçerik ekleme işlemleri
    @PostMapping("/{userId}/alreadyWatchedMovie/add/{movieId}")
    public String addToAlreadyWatchedMovie(@PathVariable String userId, @PathVariable String movieId) throws Exception {
        return userService.addToAlreadyWatchedMovie(userId, movieId);
    }

    @PostMapping("/{userId}/alreadyWatchedSeries/add/{seriesId}")
    public String addToAlreadyWatchedSeries(@PathVariable String userId, @PathVariable String seriesId) throws Exception {
        return userService.addToAlreadyWatchedSeries(userId, seriesId);
    }

    @PostMapping("/{userId}/watchLaterMovie/add/{movieId}")
    public String addToWatchLaterMovie(@PathVariable String userId, @PathVariable String movieId) throws Exception {
        return userService.addToWatchLaterMovie(userId, movieId);
    }

    @PostMapping("/{userId}/watchLaterSeries/add/{seriesId}")
    public String addToWatchLaterSeries(@PathVariable String userId, @PathVariable String seriesId) throws Exception {
        return userService.addToWatchLaterSeries(userId, seriesId);
    }
    
  



   
}
