package com.example.msd.controller;

import com.example.msd.entity.Comment;
import com.example.msd.service.CommentService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/add")
    public ResponseEntity<String> addComment(@RequestBody Comment comment) {
        try {
            String result = commentService.addComment(comment);
            return ResponseEntity.ok(result);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().body("Hata oluştu: " + e.getMessage());
        }
    }

    @GetMapping("/list/{targetId}")
    public ResponseEntity<List<Comment>> getCommentsByTargetId(@PathVariable String targetId) {
        try {
            List<Comment> comments = commentService.getCommentsByTargetId(targetId);
            return ResponseEntity.ok(comments);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Comment>> getCommentsByUserId(@PathVariable String userId) {
        try {
            List<Comment> comments = commentService.getCommentsByUserId(userId);
            return ResponseEntity.ok(comments);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @GetMapping("/list/{targetId}/sorted-by-date")
    public ResponseEntity<List<Comment>> getCommentsByTargetIdSortedByDate(@PathVariable String targetId) {
        try {
            List<Comment> sorted = commentService.getCommentsByTargetIdSortedByDate(targetId);
            return ResponseEntity.ok(sorted);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .build();
        }
    }
    
 // CommentController.java
    @GetMapping("/list/{targetId}/count")
    public ResponseEntity<Long> getCommentCountByTargetId(@PathVariable String targetId) {
        try {
            long count = commentService.getCommentCountByTargetId(targetId);
            return ResponseEntity.ok(count);
        } catch (ExecutionException | InterruptedException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    


    
    
}
