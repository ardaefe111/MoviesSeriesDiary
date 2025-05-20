package com.example.msd.service;

import com.example.msd.entity.Comment;

import java.util.List;
import java.util.concurrent.ExecutionException;

public interface CommentService {
    String addComment(Comment comment) throws ExecutionException, InterruptedException;
    List<Comment> getCommentsByTargetId(String targetId) throws ExecutionException, InterruptedException;
    List<Comment> getCommentsByUserId(String userId) throws ExecutionException, InterruptedException;
    List<Comment> getCommentsByTargetIdSortedByDate(String targetId) throws ExecutionException, InterruptedException;
    Long getCommentCountByTargetId(String targetId) throws ExecutionException, InterruptedException;
}
