package com.mansiii77.devopshonors.controller;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/")
    public Map<String, String> home() {
        return Map.of(
                "service", "devops-honors-project",
                "message", "Spring Boot is running"
        );
    }

    @GetMapping("/api/hello")
    public Map<String, String> hello() {
        return Map.of("message", "Hello from DevOps Honors Project");
    }
}
