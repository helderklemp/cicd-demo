package au.com.equifax.cicddemo;

import au.com.equifax.cicddemo.domain.SystemTest;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.junit.Test;
import org.junit.Assert;
import org.junit.After;
import org.junit.Before;
import org.junit.experimental.categories.Category;

import java.net.MalformedURLException;
import java.net.URL;

@Category(SystemTest.class)
public class SeleniumExampleTest {
    private WebDriver driver;

    @Test
    public void testOs () {
        System.out.println("APP_URL :"+System.getenv("APP_URL"));
        driver.get(System.getenv("APP_URL"));
        String bodyText = driver.findElement(By.tagName("body")).getText();
        Assert.assertTrue(bodyText.contains("Linux"));
        Assert.assertFalse(bodyText.contains("Windows"));
    }

    @Before
    public void beforeTest() throws MalformedURLException {
        driver = new RemoteWebDriver(new URL("http://selenium:4444/wd/hub"), new ChromeOptions());
    }

    @After
    public void afterTest() {
        driver.quit();
    }
}
