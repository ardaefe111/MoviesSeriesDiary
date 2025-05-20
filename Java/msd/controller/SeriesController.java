package com.example.msd.controller;

import com.example.msd.entity.Series;
import com.example.msd.service.SeriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/series")
public class SeriesController {

    private final SeriesService seriesService;

    @Autowired
    public SeriesController(SeriesService seriesService) {
        this.seriesService = seriesService;
    }

    // Dizi kaydetme
    @PostMapping("/add/{id}")
    public String saveSeries(@RequestBody Series series, @PathVariable String id) throws Exception {
        return seriesService.saveSeries(series, id);
    }

    // Dizi ID ile getirme
    @GetMapping("/get/{id}")
    public Series getSeriesById(@PathVariable String id) throws Exception {
        return seriesService.getSeriesById(id);
    }

    // Tüm dizileri listeleme
    @GetMapping("/get/all")
    public List<Series> getAllSeries() throws Exception {
        return seriesService.getAllSeries();
    }

    // Dizi silme
    @DeleteMapping("/delete/{id}")
    public String deleteSeries(@PathVariable String id) throws Exception {
        return seriesService.deleteSeries(id);
    }
    
 // IMDb’ye göre yüksekten düşüğe
    @GetMapping("/get/sorted/imdb-desc")
    public List<Series> getSeriesSortedByImdbDesc() throws Exception {
        return seriesService.getAllSeriesSortedByImdbDesc();
    }

    // IMDb’ye göre düşükten yükseğe
    @GetMapping("/get/sorted/imdb-asc")
    public List<Series> getSeriesSortedByImdbAsc() throws Exception {
        return seriesService.getAllSeriesSortedByImdbAsc();
    }
    
 // IMDb Count’a göre düşükten yükseğe
    @GetMapping("/get/sorted/imdbcount-asc")
    public ResponseEntity<List<Series>> getSeriesSortedByImdbCountAsc() throws Exception {
        List<Series> sortedList = seriesService.getAllSeriesSortedByImdbCountAsc();
        return ResponseEntity.ok(sortedList);
    }

    // IMDb Count’a göre yüksekten düşüğe
    @GetMapping("/get/sorted/imdbcount-desc")
    public ResponseEntity<List<Series>> getSeriesSortedByImdbCountDesc() throws Exception {
        List<Series> sortedList = seriesService.getAllSeriesSortedByImdbCountDesc();
        return ResponseEntity.ok(sortedList);
    }

    @GetMapping("/get/sorted/releaseyear-asc")
    public ResponseEntity<List<Series>> getSeriesByReleaseYearAsc() {
        try {
            return ResponseEntity.ok(seriesService.getAllSeriesSortedByReleaseYearAsc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Exception handling
        }
    }

    @GetMapping("/get/sorted/releaseyear-desc")
    public ResponseEntity<List<Series>> getSeriesByReleaseYearDesc() {
        try {
            return ResponseEntity.ok(seriesService.getAllSeriesSortedByReleaseYearDesc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/get/sorted/season-asc")
    public ResponseEntity<List<Series>> getSeriesSortedBySeasonAsc() {
        try {
            return ResponseEntity.ok(seriesService.getAllSeriesSortedBySeasonAsc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/get/sorted/season-desc")
    public ResponseEntity<List<Series>> getSeriesSortedBySeasonDesc() {
        try {
            return ResponseEntity.ok(seriesService.getAllSeriesSortedBySeasonDesc());
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    

}
