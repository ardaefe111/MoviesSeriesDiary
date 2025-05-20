// SeriesTreeNode.java
package com.example.msd.treenode;

import com.example.msd.entity.Series;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SeriesTreeNode {
    private Series series;
    private SeriesTreeNode left;
    private SeriesTreeNode right;
}
