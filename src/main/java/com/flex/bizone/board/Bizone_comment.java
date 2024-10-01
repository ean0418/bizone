package com.flex.bizone.board;

import java.sql.Timestamp;

public class Bizone_comment {

    private int bc_no;
    private int bc_bb_no;
    private String bc_bm_nickname;
    private String bc_content;
    private Timestamp bc_createdDate;
    private Timestamp bc_updatedDate;

    public Bizone_comment() {
    }

    public Bizone_comment(int bc_no, int bc_bb_no, String bc_bm_nickname, String bc_content, Timestamp bc_createdDate, Timestamp bc_updatedDate) {
        this.bc_no = bc_no;
        this.bc_bb_no = bc_bb_no;
        this.bc_bm_nickname = bc_bm_nickname;
        this.bc_content = bc_content;
        this.bc_createdDate = bc_createdDate;
        this.bc_updatedDate = bc_updatedDate;
    }

    public int getBc_no() {
        return bc_no;
    }

    public void setBc_no(int bc_no) {
        this.bc_no = bc_no;
    }

    public int getBc_bb_no() {
        return bc_bb_no;
    }

    public void setBc_bb_no(int bc_bb_no) {
        this.bc_bb_no = bc_bb_no;
    }

    public String getBc_bm_nickname() {
        return bc_bm_nickname;
    }

    public void setBc_bm_nickname(String bc_bm_nickname) {
        this.bc_bm_nickname = bc_bm_nickname;
    }

    public String getBc_content() {
        return bc_content;
    }

    public void setBc_content(String bc_content) {
        this.bc_content = bc_content;
    }

    public Timestamp getBc_createdDate() {
        return bc_createdDate;
    }

    public void setBc_createdDate(Timestamp bc_createdDate) {
        this.bc_createdDate = bc_createdDate;
    }

    public Timestamp getBc_updatedDate() {
        return bc_updatedDate;
    }

    public void setBc_updatedDate(Timestamp bc_updatedDate) {
        this.bc_updatedDate = bc_updatedDate;
    }
}
