package com.flex.bizone.board;

public class Bizone_like {
    private int bl_no;
    private int bl_bb_no;
    private int bl_bc_no;
    private String bl_bm_id;

    public Bizone_like() {
    }

    public Bizone_like(int bl_no, int bl_bb_no, int bl_bc_no, String bl_bm_id) {
        this.bl_no = bl_no;
        this.bl_bb_no = bl_bb_no;
        this.bl_bc_no = bl_bc_no;
        this.bl_bm_id = bl_bm_id;
    }

    public int getBl_no() {
        return bl_no;
    }

    public void setBl_no(int bl_no) {
        this.bl_no = bl_no;
    }

    public int getBl_bb_no() {
        return bl_bb_no;
    }

    public void setBl_bb_no(int bl_bb_no) {
        this.bl_bb_no = bl_bb_no;
    }

    public int getBl_bc_no() {
        return bl_bc_no;
    }

    public void setBl_bc_no(int bl_bc_no) {
        this.bl_bc_no = bl_bc_no;
    }

    public String getBl_bm_id() {
        return bl_bm_id;
    }

    public void setBl_bm_id(String bl_bm_id) {
        this.bl_bm_id = bl_bm_id;
    }
}
