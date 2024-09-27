package com.flex.bizone.member;

import java.sql.Timestamp;

public class Bizone_pw_token {
    private String bpt_token;
    private Timestamp bpt_expiration;

    public Bizone_pw_token() {

    }

    public Bizone_pw_token(String bpt_token, Timestamp bpt_expiration) {
        this.bpt_token = bpt_token;
        this.bpt_expiration = bpt_expiration;
    }

    public String getBpt_token() {
        return bpt_token;
    }

    public void setBpt_token(String bpt_token) {
        this.bpt_token = bpt_token;
    }

    public Timestamp getBpt_expiration() {
        return bpt_expiration;
    }

    public void setBpt_expiration(Timestamp bpt_expiration) {
        this.bpt_expiration = bpt_expiration;
    }
}
