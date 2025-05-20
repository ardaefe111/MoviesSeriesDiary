package com.example.msd.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {

    private String username;

    private List<String> alreadyWatchedMovieIds;
    private List<String> alreadyWatchedSeriesIds;
    private List<String> watchLaterMovieIds;
    private List<String> watchLaterSeriesIds;

    private List<Comment> comments;
    private List<Rating> ratings;
}
