package com.example.msd.treenode;

import com.example.msd.entity.Rating;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RatingTreeNode {

	    private Rating rating;
	    private RatingTreeNode left;
	    private RatingTreeNode right;
}
