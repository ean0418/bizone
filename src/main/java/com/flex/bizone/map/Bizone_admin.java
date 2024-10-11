package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Bizone_admin {
    private String ba_code;
    private String ba_name;

    public Bizone_admin() {

    }

    public Bizone_admin(String ba_code, String ba_name) {
        this.ba_code = ba_code;
        this.ba_name = ba_name;
    }
}
