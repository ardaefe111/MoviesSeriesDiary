package com.example.msd.service.impl;

import com.example.msd.entity.Comment;
import com.example.msd.entity.Rating;
import com.example.msd.entity.User;
import com.example.msd.service.UserService;
import com.google.firebase.cloud.FirestoreClient;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class UserServiceImpl implements UserService {

    private static final String COLLECTION_NAME = "users";

    @Override
    public String saveUser(User user, String id) throws Exception {
        Firestore db = FirestoreClient.getFirestore();
        db.collection(COLLECTION_NAME).document(id).set(user);
        return "Kullanıcı başarıyla kaydedildi: " + id;
    }

    @Override
    public User getUserById(String id) throws Exception {
        DocumentSnapshot snapshot = FirestoreClient.getFirestore()
                .collection(COLLECTION_NAME)
                .document(id)
                .get()
                .get();
        if (!snapshot.exists()) throw new Exception("Kullanıcı bulunamadı");
        return snapshot.toObject(User.class);
    }

    @Override
    public List<User> getAllUsers() throws Exception {
        ApiFuture<QuerySnapshot> future = FirestoreClient.getFirestore()
                .collection(COLLECTION_NAME)
                .get();
        List<User> users = new ArrayList<>();
        for (DocumentSnapshot doc : future.get().getDocuments()) {
            users.add(doc.toObject(User.class));
        }
        return users;
    }

    @Override
    public String deleteUser(String id) throws Exception {
        FirestoreClient.getFirestore()
                .collection(COLLECTION_NAME)
                .document(id)
                .delete();
        return "Kullanıcı silindi: " + id;
    }

    @Override
    public String addToAlreadyWatchedMovie(String userId, String movieId) throws Exception {
        return addToList(userId, "alreadyWatchedMovieIds", movieId);
    }

    @Override
    public String addToAlreadyWatchedSeries(String userId, String seriesId) throws Exception {
        return addToList(userId, "alreadyWatchedSeriesIds", seriesId);
    }

    @Override
    public String addToWatchLaterMovie(String userId, String movieId) throws Exception {
        return addToList(userId, "watchLaterMovieIds", movieId);
    }

    @Override
    public String addToWatchLaterSeries(String userId, String seriesId) throws Exception {
        return addToList(userId, "watchLaterSeriesIds", seriesId);
    }
    



  



    //yukarıdaki methodlarda kullanılan method
    private String addToList(String userId, String field, String value) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(userId);
        docRef.update(field, FieldValue.arrayUnion(value));
        return field + " alanına eklendi: " + value;
    }
}
