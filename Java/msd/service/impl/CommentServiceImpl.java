package com.example.msd.service.impl;

import com.example.msd.entity.Comment;
import com.example.msd.service.CommentService;
import com.example.msd.treenode.CommentTreeNode;
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
public class CommentServiceImpl implements CommentService {

    private static final String COLLECTION_NAME = "comments";

    @Override
    public String addComment(Comment comment) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        comment.setCreatedDate(Timestamp.now());
        ApiFuture<DocumentReference> future = db.collection(COLLECTION_NAME).add(comment);
        return "Yorum eklendi: " + future.get().getId();
    }


    @Override
    public List<Comment> getCommentsByTargetId(String targetId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        CollectionReference commentsRef = db.collection(COLLECTION_NAME);
        Query query = commentsRef.whereEqualTo("targetId", targetId);
        ApiFuture<QuerySnapshot> future = query.get();

        List<Comment> comments = new ArrayList<>();
        for (DocumentSnapshot doc : future.get().getDocuments()) {
            comments.add(doc.toObject(Comment.class));
        }
        return comments;
    }

	@Override
	public List<Comment> getCommentsByUserId(String userId) throws ExecutionException, InterruptedException {
		  Firestore db = FirestoreClient.getFirestore();
		    CollectionReference commentsRef = db.collection(COLLECTION_NAME);
		    Query query = commentsRef.whereEqualTo("userId", userId);
		    ApiFuture<QuerySnapshot> future = query.get();

		    List<Comment> comments = new ArrayList<>();
		    for (DocumentSnapshot doc : future.get().getDocuments()) {
		        comments.add(doc.toObject(Comment.class));
		    }
		    return comments;
	}
	
	    @Override
	    public List<Comment> getCommentsByTargetIdSortedByDate(String targetId) throws ExecutionException, InterruptedException {
	        List<Comment> comments = getCommentsByTargetId(targetId);
	        LinkedList<Comment> list = new LinkedList<>(comments);
	        list.sort((c1, c2) -> c2.getCreatedDate().compareTo(c1.getCreatedDate())); 
	        return list;
	    }
	    
	    
	 //bu alttaki 3 method beraber
	    @Override
	    public Long getCommentCountByTargetId(String targetId) throws ExecutionException, InterruptedException {
	        List<Comment> comments = getCommentsByTargetId(targetId);
	        // 1) BST’yi kur
	        CommentTreeNode root = null;
	        for (Comment c : comments) {
	            root = insert(root, c);
	        }

	        // 2) Düğüm sayısını döndür
	        return countNodes(root);
	    }
	    private CommentTreeNode insert(CommentTreeNode node, Comment c) {
	        if (node == null) {
	            return new CommentTreeNode(c, null, null);
	        }
	        // Tarihe göre ekleme yapıyoruz (örnek: createdDate küçükse sola)
	        if (c.getCreatedDate().compareTo(node.getComment().getCreatedDate()) < 0) {
	            node.setLeft(insert(node.getLeft(), c));
	        } else {
	            node.setRight(insert(node.getRight(), c));
	        }
	        return node;
	    }
	    private long countNodes(CommentTreeNode node) {
	        if (node == null) return 0;
	        return 1 + countNodes(node.getLeft()) + countNodes(node.getRight());
	    }



}

	


	

