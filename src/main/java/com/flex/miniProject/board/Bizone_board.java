package com.flex.miniProject.board;

import java.sql.Timestamp;

public class Bizone_board {
    private int bb_no;
    private String bb_bm_nickname;
    private String bb_title;
    private String bb_content;
    private int bb_readcount;
    private Timestamp bb_date;

    public Bizone_board() {
    }

    public Bizone_board(int bb_no, String bb_bm_nickname, String bb_title, String bb_content, int bb_readcount, Timestamp bb_date) {
        this.bb_no = bb_no;
        this.bb_bm_nickname = bb_bm_nickname;
        this.bb_title = bb_title;
        this.bb_content = bb_content;
        this.bb_readcount = bb_readcount;
        this.bb_date = bb_date;
    }

    public int getBb_no() {
        return bb_no;
    }

    public void setBb_no(int bb_no) {
        this.bb_no = bb_no;
    }

    public String getBb_bm_nickname() {
        return bb_bm_nickname;
    }

    public void setBb_bm_nickname(String bb_bm_nickname) {
        this.bb_bm_nickname = bb_bm_nickname;
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

    public int getBb_readcount() {
        return bb_readcount;
    }

    public void setBb_readcount(int bb_readcount) {
        this.bb_readcount = bb_readcount;
    }

    public Timestamp getBb_date() {
        return bb_date;
    }

    public void setBb_date(Timestamp bb_date) {
        this.bb_date = bb_date;
    }
}

