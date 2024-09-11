package com.flex.miniProject.member;

import java.util.List;

public class Members {
    private List<bizone_member> member;

    public Members() {

    }

    public Members(List<bizone_member> member) {
        this.member = member;
    }

    public List<bizone_member> getMember() {
        return member;
    }

    public void setMember(List<bizone_member> member) {
        this.member = member;
    }
}
