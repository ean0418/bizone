package com.flex.miniProject.board;

import java.sql.Timestamp;

public class Bizone_board {
    private int bn_no;
    private String bn_bm_nickname;
    private String bn_title;
    private String bn_content;
    private int bn_readcount;
    private Timestamp bn_date;

    public Bizone_board() {
    }

    public Bizone_board(int bn_no, String bn_bm_nickname, String bn_title, String bn_content, int bn_readcount, Timestamp bn_date) {
        this.bn_no = bn_no;
        this.bn_bm_nickname = bn_bm_nickname;
        this.bn_title = bn_title;
        this.bn_content = bn_content;
        this.bn_readcount = bn_readcount;
        this.bn_date = bn_date;
    }

    public int getBn_no() {
        return bn_no;
    }

    public void setBn_no(int bn_no) {
        this.bn_no = bn_no;
    }

    public String getBn_bm_nickname() {
        return bn_bm_nickname;
    }

    public void setBn_bm_nickname(String bn_bm_nickname) {
        this.bn_bm_nickname = bn_bm_nickname;
    }

    public String getBn_title() {
        return bn_title;
    }

    public void setBn_title(String bn_title) {
        this.bn_title = bn_title;
    }

    public String getBn_content() {
        return bn_content;
    }

    public void setBn_content(String bn_content) {
        this.bn_content = bn_content;
    }

    public int getBn_readcount() {
        return bn_readcount;
    }

    public void setBn_readcount(int bn_readcount) {
        this.bn_readcount = bn_readcount;
    }

    public Timestamp getBn_date() {
        return bn_date;
    }

    public void setBn_date(Timestamp bn_date) {
        this.bn_date = bn_date;
    }
}
