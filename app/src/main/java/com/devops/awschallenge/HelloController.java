
package com.devops.awschallenge;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public Map<String, String> hello() {

        return Map.of(
            "message", "Hola Mundo desde AWS DevOps Challenge",
            "status", "OK",
            "technology", "Java 21 + Spring Boot",
            "deployment", "AWS ECS Fargate"
        );
    }
}
