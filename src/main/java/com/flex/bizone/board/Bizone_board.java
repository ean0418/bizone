package com.flex.bizone.board;

import java.sql.Timestamp;

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

    public int getBb_no() {
        return bb_no;
    }

    public void setBb_no(int bb_no) {
        this.bb_no = bb_no;
    }

    public int getBb_postNum() {
        return bb_postNum;
    }

    public void setBb_postNum(int bb_postNum) {
        this.bb_postNum = bb_postNum;
    }

    public String getBb_bm_id() {
        return bb_bm_id;
    }

    public void setBb_bm_id(String bb_bm_id) {
        this.bb_bm_id = bb_bm_id;
    }

    public String getBb_title() {
        return bb_title;
    }

    public void setBb_title(String bb_title) {
        this.bb_title = bb_title;
    }

    public String getBb_content() {
        return bb_content;
    }

    public void setBb_content(String bb_content) {
        this.bb_content = bb_content;
    }

    public Timestamp getBb_date() {
        return bb_date;
    }

    public void setBb_date(Timestamp bb_date) {
        this.bb_date = bb_date;
    }

    public int getBb_readCount() {
        return bb_readCount;
    }

    public void setBb_readCount(int bb_readCount) {
        this.bb_readCount = bb_readCount;
    }

    public int getBb_likeCount() {
        return bb_likeCount;
    }

    public void setBb_likeCount(int bb_likeCount) {
        this.bb_likeCount = bb_likeCount;
    }
}

