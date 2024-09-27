package com.flex.bizone.member;

import java.sql.Timestamp;

public class KakaoVO {
    private String bk_id;
    private String bk_nickname;
    private String bk_profile_image_url;
    private Timestamp bk_created_at;

    public KakaoVO() {

    }

    public String getBk_id() {
        return bk_id;
    }

    public void setBk_id(String bk_id) {
        this.bk_id = bk_id;
    }

    public String getBk_nickname() {
        return bk_nickname;
    }

    public void setBk_nickname(String bk_nickname) {
        this.bk_nickname = bk_nickname;
    }

    public String getBk_profile_image_url() {
        return bk_profile_image_url;
    }

    public void setBk_profile_image_url(String bk_profile_image_url) {
        this.bk_profile_image_url = bk_profile_image_url;
    }

    public Timestamp getBk_created_at() {
        return bk_created_at;
    }

    public void setBk_created_at(Timestamp bk_created_at) {
        this.bk_created_at = bk_created_at;
    }

    public KakaoVO(String bk_id, String bk_nickname, String bk_profile_image_url, Timestamp bk_created_at) {
        this.bk_id = bk_id;
        this.bk_nickname = bk_nickname;
        this.bk_profile_image_url = bk_profile_image_url;
        this.bk_created_at = bk_created_at;
    }
}
