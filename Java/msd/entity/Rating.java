// Rating.java
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
public class Rating {
	private Double score; // 1 - 10
    private String userId;
    private String targetId; // movieId veya seriesId
    private String type; // "movie" veya "series"/ 1.0 - 10.0 arası örneğin
    private Timestamp createdDate;
}
