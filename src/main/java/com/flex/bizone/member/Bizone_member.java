package com.flex.bizone.member;


import java.sql.Date;

public class Bizone_member {
    private String bm_id;
    private String bm_pw;
    private String bm_name;
    private String bm_nickname;
    private String bm_address;
    private String bm_phoneNum;
    private Date bm_birthday;
    private String bm_mail;

    public Bizone_member() {

    }

    public Bizone_member(String bm_id, String bm_pw, String bm_name, String bm_nickname, String bm_address, String bm_phoneNum, Date bm_birthday, String bm_mail) {
        this.bm_id = bm_id;
        this.bm_pw = bm_pw;
        this.bm_name = bm_name;
        this.bm_nickname = bm_nickname;
        this.bm_address = bm_address;
        this.bm_phoneNum = bm_phoneNum;
        this.bm_birthday = bm_birthday;
        this.bm_mail = bm_mail;
    }

    public String getBm_id() {
        return bm_id;
    }

    public void setBm_id(String bm_id) {
        this.bm_id = bm_id;
    }

    public String getBm_pw() {
        return bm_pw;
    }

    public void setBm_pw(String bm_pw) {
        this.bm_pw = bm_pw;
    }

    public String getBm_name() {
        return bm_name;
    }

    public void setBm_name(String bm_name) {
        this.bm_name = bm_name;
    }

    public String getBm_nickname() {
        return bm_nickname;
    }

    public void setBm_nickname(String bm_nickname) {
        this.bm_nickname = bm_nickname;
    }

    public String getBm_address() {
        return bm_address;
    }

    public void setBm_address(String bm_address) {
        this.bm_address = bm_address;
    }

    public String getBm_phoneNum() {
        return bm_phoneNum;
    }

    public void setBm_phoneNum(String bm_phoneNum) {
        this.bm_phoneNum = bm_phoneNum;
    }

    public Date getBm_birthday() {
        return bm_birthday;
    }

    public void setBm_birthday(Date bm_birthday) {
        this.bm_birthday = bm_birthday;
    }

    public String getBm_mail() {
        return bm_mail;
    }

    public void setBm_mail(String bm_mail) {
        this.bm_mail = bm_mail;
    }
}
