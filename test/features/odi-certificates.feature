@odi-certificates
Feature: ODI Certificates

    Background:
        Given "Admin" as the persona
        When I log in

    Scenario: Create a new test organisation for subsequent tests
        Then I go to add new organisation
        When I fill in "title" with "Test Organisation"
        When I press "save"

    Scenario: Add a test dataset to the test organisation that we know has an ODI certificate
        Then I create a dataset with title "Youth Justice - Young offenders in youth detention" and notes "A description"

    Scenario: Add a test dataset to the test organisation that we know does not have an ODI certificate
        Then I create a dataset with title "Test dataset without ODI certificate" and notes "A description"

    Scenario: Check the test dataset with known ODI certificate to ensure certificate badge displays on dataset detail page
        When I go to dataset "youth-justice-young-offenders-in-youth-detention"
        Then the element with the css selector "#odi_certificates" should be visible within 10 seconds
        Then I should see "Open Data Certificate Awarded" within 10 seconds
        Then I take a screenshot

    Scenario: Check the test dataset without ODI certificate to ensure certificate badge does not display on dataset detail page
        When I go to dataset "test-dataset-without-odi-certificate"
        Then the element with the css selector "#odi_certificates" should not be visible within 10 seconds
        Then I should not see "Open Data Certificate Awarded" within 10 seconds
