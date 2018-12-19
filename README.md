
This project aims to be the basic skeleton to apply continuous integration and continuous delivery to Equifax.

## Topology 

CICD Demo uses some kubernetes primitives to deploy:
* Deployment
* Services 
* Ingress ( with TLS )

   ```
     internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]
   --|-----|--
   [   Pods   ]

   ```

This project includes:

* Spring Boot java app 
* Jenkinsfile integration to run pipelines
* Dockerfile containing the base image to run java apps in Equifax
* Makefile and docker-compose to make the pipeline steps much simpler
* Kubernetes deployment file demonstrating how to deploy this app in a simple Kubernetes cluster



## Pipeline Setup

Pipelines exist at http://jenkins.anzcd.internal.

Some pipelines are configured by **Bitbucket Team/Project**. If you have created a repository in one of these, your project will be **automatically** built if it has a Jenkinsfile (if not, hit the `Scan Organization Folder Now` button).

Other pipelines are configured manually under folders. You can create a project manually with the following steps:

  * New Item
  * `item name`: repository name
  * Multibranch Pipeline
  * Branch Sources -> Add source -> Bitbucket
    * Server: `EFX Bitbucket (https://bitbucket.corp.dmz)`
    * Choose appropriate credentials
    * Owner: the Bitbucket Team/Project your repository exists under
    * Pick your repository from the dropdown.
  * All other configuration is default.

How to run the app:

## Testing

Unit tests and integrations tests are separated using [JUnit Categories][].

[JUnit Categories]: https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit.html

### Unit Tests

```java
mvn test -Dgroups=UnitTest
```

Or using Docker:
```bash
make build
```

### Integration Tests

```java
mvn integration-test -Dgroups=IntegrationTests
```

Or using Docker:
```bash
make integrationTest
```

### System Tests

System tests run with Selenium using docker-compose to run a [Selenium standalone container][] with Chrome.

[Selenium standalone container]: https://github.com/SeleniumHQ/docker-selenium

Using Docker:
  * If you are running locally, make sure the `$APP_URL` is populated and points to a valid instance of your application. This variable is populated automatically in Jenkins.
```bash
APP_URL=http://dev-cicd-demo-master.anzcd.internal/ make systemTest
```



