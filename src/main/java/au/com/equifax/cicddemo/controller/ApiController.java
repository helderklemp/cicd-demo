package au.com.equifax.cicddemo.controller;

import au.com.equifax.cicddemo.domain.EnvDetail;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class ApiController {

    @RequestMapping("/")
    public EnvDetail greeting() throws UnknownHostException {
        EnvDetail env=new EnvDetail();
        InetAddress inetAddress = InetAddress.getLocalHost();
        env.setHostname(inetAddress.getHostName());
        env.setIp(inetAddress.getHostAddress());
        env.setOs(System.getProperty("os.name"));
        return env;
    }
}
