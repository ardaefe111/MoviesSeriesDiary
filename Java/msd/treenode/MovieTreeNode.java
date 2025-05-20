// MovieTreeNode.java
package com.example.msd.treenode;

import com.example.msd.entity.Movie;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MovieTreeNode {
    private Movie movie;
    private MovieTreeNode left;
    private MovieTreeNode right;
}
