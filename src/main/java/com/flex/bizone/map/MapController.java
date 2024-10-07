package com.flex.bizone.map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;

@Controller
public class MapController {

    @GetMapping("/map/detail")
    public String showDetailInfo(Model model) {
        model.addAttribute("contentPage", "map/detailInfo.jsp");
        return "index";  // index.jsp를 반환하여 ${contentPage}가 동적으로 detailInfo.jsp를 로드하도록 함
    }
}

