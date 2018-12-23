package au.com.equifax.cicddemo;

import au.com.equifax.cicddemo.domain.UnitTest;
import au.com.equifax.cicddemo.domain.User;
import au.com.equifax.cicddemo.service.UserService;
import au.com.equifax.cicddemo.service.UserServiceImpl;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.experimental.categories.Category;

@Category(UnitTest.class)
public class UserServiceTest {

    private UserService service;

    @Before
    public void setUp() {
        service=new UserServiceImpl();
    }

    @Test
    public void addUSerTest(){
        User usr =User.UserBuilder.anUser()
                .withEmail("helderklemp@gmail.com")
                .withLogin("hklemp")
                .withName("Helder Klemp").build();
        service.save(usr);
        Assert.assertEquals(1,service.getUsersTotal());
    }
    @Test(expected = IllegalArgumentException.class)
    public void validateUserTest(){

        //BAsic User
        User usr =User.UserBuilder.anUser()
                .withEmail("helderklemp@gmail.com").build();
        service.save(usr);

    }
    @Test
    public void validateUserCollectionTest(){


        User usr =User.UserBuilder.anUser()
                .withEmail("another@gmail.com")
                .withLogin("another")
                .withName("another").build();
        service.save(usr);


        service.getUsers().stream().forEach(user ->
                Assert.assertEquals(user,usr));

    }

    @Test
    public void validateFindByIdTest(){


        User usr =User.UserBuilder.anUser()
                .withEmail("another@gmail.com")
                .withLogin("another")
                .withId(10)
                .withName("another").build();
        service.save(usr);


        Assert.assertEquals(usr,service.findById(10).get());
    }


}
