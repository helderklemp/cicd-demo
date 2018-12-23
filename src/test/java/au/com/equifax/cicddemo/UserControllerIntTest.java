package au.com.equifax.cicddemo;

import au.com.equifax.cicddemo.domain.IntegrationTest;
import au.com.equifax.cicddemo.domain.UnitTest;
import au.com.equifax.cicddemo.domain.User;
import org.json.JSONException;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.junit.runner.RunWith;
import org.skyscreamer.jsonassert.JSONAssert;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@Category(IntegrationTest.class)
@SpringBootTest(classes = CicdDemoApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserControllerIntTest {

    @LocalServerPort
    private int port;

    TestRestTemplate restTemplate = new TestRestTemplate();

    HttpHeaders headers = new HttpHeaders();


    @Test
    public void testRetrieveStudentCourse() throws JSONException {

        HttpEntity<String> entity = new HttpEntity<String>(null, headers);

        ResponseEntity<String> response = restTemplate.exchange(
                createURLWithPort("/users/"),
                HttpMethod.GET, entity, String.class);

        //String expected = "{id:Course1,name:Spring,description:10 Steps}";
        String expected = "[]";
        // Empty
        JSONAssert.assertEquals(expected, response.getBody(), false);


        User usr =User.UserBuilder.anUser()
                .withEmail("another@gmail.com")
                .withLogin("another")
                .withId(10)
                .withName("another").build();
        HttpEntity<User> entityUsr = new HttpEntity<>(usr, headers);

        //Post
        restTemplate.exchange(
                createURLWithPort("/users/"),
                HttpMethod.POST, entityUsr, User.class);

        //Get By ID

        ResponseEntity<User> responseUsr = restTemplate.exchange(
                createURLWithPort("/users/"+usr.getId()),
                HttpMethod.GET, entityUsr, User.class);
        //responseUsr.getBody()
        Assert.assertEquals(usr, responseUsr.getBody());

    }

    private String createURLWithPort(String uri) {
        return "http://localhost:" + port + uri;
    }
}
