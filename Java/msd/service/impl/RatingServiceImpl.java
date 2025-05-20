package com.example.msd.service.impl;

import com.example.msd.entity.Rating;
import com.example.msd.service.RatingService;
import com.example.msd.treenode.RatingTreeNode;
import com.google.api.core.ApiFuture;
import com.google.cloud.Timestamp;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class RatingServiceImpl implements RatingService {

    private static final String COLLECTION_NAME = "ratings";

    @Override
    public String addRating(Rating rating) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        rating.setCreatedDate(Timestamp.now());
        ApiFuture<DocumentReference> future = db.collection(COLLECTION_NAME).add(rating);
        return "Puan eklendi: " + future.get().getId();
    }


    @Override
    public List<Rating> getRatingsByTargetId(String targetId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        CollectionReference ratingsRef = db.collection(COLLECTION_NAME);
        Query query = ratingsRef.whereEqualTo("targetId", targetId);
        ApiFuture<QuerySnapshot> future = query.get();

        List<Rating> ratings = new ArrayList<>();
        for (DocumentSnapshot doc : future.get().getDocuments()) {
            ratings.add(doc.toObject(Rating.class));
        }
        return ratings;
    }

    @Override
    public Double calculateAverageRating(String targetId) throws ExecutionException, InterruptedException {
        List<Rating> ratings = getRatingsByTargetId(targetId);
        if (ratings.isEmpty()) return null;

        double total = 0.0;
        for (Rating r : ratings) {
            total += r.getScore();
        }
        return total / ratings.size();
    }

    @Override
    public List<Rating> getRatingsByUserId(String userId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        CollectionReference ratingsRef = db.collection(COLLECTION_NAME);
        Query query = ratingsRef.whereEqualTo("userId", userId);
        ApiFuture<QuerySnapshot> future = query.get();

        List<Rating> ratings = new ArrayList<>();
        for (DocumentSnapshot doc : future.get().getDocuments()) {
            ratings.add(doc.toObject(Rating.class));
        }
        return ratings;
    }
    
    @Override
    public List<Rating> getRatingsByTargetIdSortedByDate(String targetId) throws ExecutionException, InterruptedException {
        List<Rating> ratings = getRatingsByTargetId(targetId);

        LinkedList<Rating> list = new LinkedList<>(ratings);
        list.sort((r1, r2) -> r2.getCreatedDate().compareTo(r1.getCreatedDate()));
        return list;
    }
    
    //alttaki 3 method birbriyle beraber kullanılıyor
    @Override
    public List<Rating> getRatingsFilteredByScore(String targetId, Double minScore, Double maxScore) throws ExecutionException, InterruptedException {
        List<Rating> ratings = getRatingsByTargetId(targetId); // mevcut tüm ratingleri getiriyoruz

        // 1. Ağaç yapısını kurmak
        RatingTreeNode root = null;
        for (Rating rating : ratings) {
            root = insert(root, rating);
        }

        // 2. Şimdi ağacı dolaşıp aralıktaki ratingleri toplayacağız
        List<Rating> result = new ArrayList<>();
        inOrderTraversal(root, minScore, maxScore, result);

        return result;
    }
    private RatingTreeNode insert(RatingTreeNode root, Rating rating) {
        if (root == null) {
            return new RatingTreeNode(rating, null, null);
        }

        if (rating.getScore() < root.getRating().getScore()) {
            root.setLeft(insert(root.getLeft(), rating));
        } else {
            root.setRight(insert(root.getRight(), rating));
        }

        return root;
    }
    private void inOrderTraversal(RatingTreeNode root, Double minScore, Double maxScore, List<Rating> result) {
        if (root == null) {
            return;
        }

        // Sol alt ağacı tara
        inOrderTraversal(root.getLeft(), minScore, maxScore, result);

        // Şu anki node'un skorunu kontrol et
        double score = root.getRating().getScore();
        if (score >= minScore && score <= maxScore) {
            result.add(root.getRating());
        }

        // Sağ alt ağacı tara
        inOrderTraversal(root.getRight(), minScore, maxScore, result);
    }


    



}
