package au.com.equifax.cicddemo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ConfigController {

    @Value("${application.name}")
    private String name;

    @GetMapping("/config")
    public String config() {
        return "Current profile "+name;
    }
}
