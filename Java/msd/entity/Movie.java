package com.example.msd.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Movie {

    private String id;
    private String director;
    private String actors;
    private String awards;
    private String category;
    private String country;
    private String description;
    private Double imdb;
    private String imdbCount;
    private String posterURL;
    private Integer releaseYear;
    private Integer runtime;

  
}
