package com.flex.bizone.board;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
public class Bizone_board {
    private int bb_no;
    private int bb_postNum;
    private String bb_bm_id;
    private String bb_title;
    private String bb_content;
    private Timestamp bb_date;
    private int bb_readCount;
    private int bb_likeCount;

    public Bizone_board() {
    }

    public Bizone_board(int bb_no, int bb_postNum, String bb_bm_id, String bb_title, String bb_content, Timestamp bb_date, int bb_readCount, int bb_likeCount) {
        this.bb_no = bb_no;
        this.bb_postNum = bb_postNum;
        this.bb_bm_id = bb_bm_id;
        this.bb_title = bb_title;
        this.bb_content = bb_content;
        this.bb_date = bb_date;
        this.bb_readCount = bb_readCount;
        this.bb_likeCount = bb_likeCount;
    }

}

