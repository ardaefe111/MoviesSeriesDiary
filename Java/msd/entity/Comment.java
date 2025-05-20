// Comment.java
package com.example.msd.entity;

import java.time.LocalDateTime;

import com.google.cloud.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
	private String content;
    private String userId;
    private String targetId; // movieId veya seriesId
    private String type; // "movie" veya "series"
    private Timestamp createdDate;
}
