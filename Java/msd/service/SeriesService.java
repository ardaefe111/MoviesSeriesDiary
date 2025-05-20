package com.example.msd.service;

import com.example.msd.entity.Series;
import java.util.List;
import java.util.concurrent.ExecutionException;

public interface SeriesService {
    String saveSeries(Series series, String id) throws ExecutionException, InterruptedException;
    Series getSeriesById(String id) throws ExecutionException, InterruptedException;
    List<Series> getAllSeries() throws ExecutionException, InterruptedException;
    String deleteSeries(String id) throws ExecutionException, InterruptedException;
    List<Series> getAllSeriesSortedByImdbAsc() throws ExecutionException, InterruptedException;
    List<Series> getAllSeriesSortedByImdbDesc() throws ExecutionException, InterruptedException;
    List<Series> getAllSeriesSortedByImdbCountAsc() throws ExecutionException, InterruptedException;
    List<Series> getAllSeriesSortedByImdbCountDesc() throws ExecutionException, InterruptedException;
    List<Series> getAllSeriesSortedByReleaseYearAsc() throws Exception; 
    List<Series> getAllSeriesSortedByReleaseYearDesc() throws Exception;
    List<Series> getAllSeriesSortedBySeasonAsc() throws Exception;
    List<Series> getAllSeriesSortedBySeasonDesc() throws Exception;


}
