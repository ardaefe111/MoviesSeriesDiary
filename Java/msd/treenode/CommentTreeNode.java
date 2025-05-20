package com.example.msd.treenode;

import com.example.msd.entity.Comment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentTreeNode {
	 private Comment comment;
	 private CommentTreeNode left;
	 private CommentTreeNode right;

}
