package com.damvinod.hello.world;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.ResponseEntity.status;

@RestController
public class HelloWorldController {

    @GetMapping(path = "/hello")
    public ResponseEntity<String> helloWorld() {
        return status(HttpStatus.OK).body("Hello");
    }
}
