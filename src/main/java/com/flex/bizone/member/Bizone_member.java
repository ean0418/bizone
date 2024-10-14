package com.flex.bizone.member;

import lombok.Getter;
import lombok.Setter;

import java.sql.Date;

@Setter
@Getter
public class Bizone_member {
    private String bm_id;
    private String bm_pw;
    private String bm_name;
    private String bm_nickname;
    private String bm_address;
    private String bm_phoneNum;
    private Date bm_birthday;
    private String bm_mail;
    private Date bm_signupDate;

    public Bizone_member() {

    }

    public Bizone_member(String bm_id, String bm_pw, String bm_name, String bm_nickname, String bm_address, String bm_phoneNum, Date bm_birthday, String bm_mail, Date bm_signupDate) {
        this.bm_id = bm_id;
        this.bm_pw = bm_pw;
        this.bm_name = bm_name;
        this.bm_nickname = bm_nickname;
        this.bm_address = bm_address;
        this.bm_phoneNum = bm_phoneNum;
        this.bm_birthday = bm_birthday;
        this.bm_mail = bm_mail;
        this.bm_signupDate = bm_signupDate;
    }

}
