package com.damvinod.hello.world;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.http.ResponseEntity.status;

@RestController
@Slf4j
public class HelloWorldController {

    @GetMapping(path = "/hello")
    public ResponseEntity<String> helloWorld() {
        log.info("Hello world Service controller invoked.");
        return status(HttpStatus.OK).body("Hello");
    }
}
