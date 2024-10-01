package com.flex.bizone.member;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Setter
@Getter
public class KakaoVO {
    private String bk_id;
    private String bk_nickname;
    private String bk_profile_image_url;
    private Timestamp bk_created_at;

    public KakaoVO() {

    }

    public KakaoVO(String bk_id, String bk_nickname, String bk_profile_image_url, Timestamp bk_created_at) {
        this.bk_id = bk_id;
        this.bk_nickname = bk_nickname;
        this.bk_profile_image_url = bk_profile_image_url;
        this.bk_created_at = bk_created_at;
    }
}
