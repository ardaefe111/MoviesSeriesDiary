package com.example.msd.service.impl;

import com.example.msd.entity.Series;
import com.example.msd.service.SeriesService;
import com.example.msd.treenode.SeriesBST;
import com.example.msd.treenode.SeriesBSTByCount;
import com.example.msd.treenode.SeriesBSTByReleaseYear;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class SeriesServiceImpl implements SeriesService {

    private final Firestore firestore;

    @Autowired
    public SeriesServiceImpl(Firestore firestore) {
        this.firestore = firestore;
    }

    @Override
    public String saveSeries(Series series, String id) throws ExecutionException, InterruptedException {
        ApiFuture<WriteResult> result = firestore.collection("series").document(id).set(series);
        return "Dizi kaydedildi: " + result.get().getUpdateTime();
    }

    @Override
    public Series getSeriesById(String id) throws ExecutionException, InterruptedException {
        DocumentSnapshot snapshot = firestore.collection("series").document(id).get().get();
        return snapshot.exists() ? snapshot.toObject(Series.class) : null;
    }

    @Override
    public List<Series> getAllSeries() throws ExecutionException, InterruptedException {
        return firestore.collection("series").get().get().toObjects(Series.class);
    }

    @Override
    public String deleteSeries(String id) throws ExecutionException, InterruptedException {
        ApiFuture<WriteResult> result = firestore.collection("series").document(id).delete();
        return "Dizi silindi: " + result.get().getUpdateTime();
    }
    
    @Override
    public List<Series> getAllSeriesSortedByImdbAsc() throws ExecutionException, InterruptedException {
        List<Series> allSeries = getAllSeries();
        SeriesBST bst = new SeriesBST();
        for (Series series : allSeries) {
            bst.insert(series);
        }
        return bst.inOrderAsc();
    }

    @Override
    public List<Series> getAllSeriesSortedByImdbDesc() throws ExecutionException, InterruptedException {
        List<Series> allSeries = getAllSeries();
        SeriesBST bst = new SeriesBST();
        for (Series series : allSeries) {
            bst.insert(series);
        }
        return bst.inOrderDesc();
    }
    
    @Override
    public List<Series> getAllSeriesSortedByImdbCountAsc() throws ExecutionException, InterruptedException {
        List<Series> allSeries = getAllSeries();
        SeriesBSTByCount bst = new SeriesBSTByCount();
        for (Series series : allSeries) {
            bst.insert(series);
        }
        return bst.inOrderAsc();
    }

    @Override
    public List<Series> getAllSeriesSortedByImdbCountDesc() throws ExecutionException, InterruptedException {
        List<Series> allSeries = getAllSeries();
        SeriesBSTByCount bst = new SeriesBSTByCount();
        for (Series series : allSeries) {
            bst.insert(series);
        }
        return bst.inOrderDesc();
    }

    @Override
    public List<Series> getAllSeriesSortedByReleaseYearAsc() throws Exception {
        List<Series> seriesList = getAllSeries();  // Exception handling burada yapılacak
        SeriesBSTByReleaseYear bst = new SeriesBSTByReleaseYear();
        for (Series series : seriesList) {
            bst.insert(series);  // Eğer insert sırasında bir hata varsa, exception fırlatılacak
        }
        return bst.inOrderAsc();
    }

    @Override
    public List<Series> getAllSeriesSortedByReleaseYearDesc() throws Exception {
        List<Series> seriesList = getAllSeries();  // Exception handling burada yapılacak
        SeriesBSTByReleaseYear bst = new SeriesBSTByReleaseYear();
        for (Series series : seriesList) {
            bst.insert(series);
        }
        return bst.inOrderDesc();
    }
    
    @Override
    public List<Series> getAllSeriesSortedBySeasonAsc() throws Exception {
        List<Series> seriesList = getAllSeries();  // Firestore'dan çekiyoruz
        LinkedList<Series> sortedList = new LinkedList<>();

        for (Series series : seriesList) {
            if (sortedList.isEmpty()) {
                sortedList.add(series);
            } else {
                int i = 0;
                while (i < sortedList.size() && series.getSeason() > sortedList.get(i).getSeason()) {
                    i++;
                }
                sortedList.add(i, series);  // Doğru yere ekle
            }
        }
        return sortedList;
    }
    
    @Override
    public List<Series> getAllSeriesSortedBySeasonDesc() throws Exception {
        List<Series> seriesList = getAllSeries();
        LinkedList<Series> sortedList = new LinkedList<>();

        for (Series series : seriesList) {
            if (sortedList.isEmpty()) {
                sortedList.add(series);
            } else {
                int i = 0;
                while (i < sortedList.size() && series.getSeason() < sortedList.get(i).getSeason()) {
                    i++;
                }
                sortedList.add(i, series);
            }
        }
        return sortedList;
    }



}
