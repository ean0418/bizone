package com.flex.miniProject.member;

import java.util.List;

public class Members {
    private List<Bizone_member> member;

    public Members() {
    }

    public Members(List<Bizone_member> member) {
        this.member = member;
    }

    public List<Bizone_member> getMember() {
        return member;
    }

    public void setMember(List<Bizone_member> member) {
        this.member = member;
    }
}
