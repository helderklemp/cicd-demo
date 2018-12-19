package au.com.equifax.cicddemo;

import au.com.equifax.cicddemo.domain.IntegrationTest;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
@Category(IntegrationTest.class)
public class CicdDemoApplicationTests {

    @Test
    public void contextLoads() {
    }

}
