package com.flex.bizone.board;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
public class CommentList {
    private int bc_no;
    private int bc_bb_no;
    private String bc_bm_id;
    private String bc_content;
    private Timestamp bc_createdDate;
    private Timestamp bc_updatedDate;
    private int bc_likeCount;
    private int likeComment;

    public CommentList() {
    }

    public CommentList(int bc_no, int bc_bb_no, String bc_bm_id, String bc_content, Timestamp bc_createdDate, Timestamp bc_updatedDate, int bc_likeCount, int likeComment) {
        this.bc_no = bc_no;
        this.bc_bb_no = bc_bb_no;
        this.bc_bm_id = bc_bm_id;
        this.bc_content = bc_content;
        this.bc_createdDate = bc_createdDate;
        this.bc_updatedDate = bc_updatedDate;
        this.bc_likeCount = bc_likeCount;
        this.likeComment = likeComment;
    }
}
