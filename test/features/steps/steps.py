from behave import when
from behaving.web.steps import *  # noqa: F401, F403
from behaving.personas.steps import *  # noqa: F401, F403
from behaving.web.steps.url import when_i_visit_url


@step('I go to homepage')
def go_to_home(context):
    when_i_visit_url(context, '/')


@step('I go to add new dataset')
def go_to_add_new_dataset(context):
    when_i_visit_url(context, '/dataset/new')


@step('I go to add new organisation')
def go_to_add_new_organisation(context):
    when_i_visit_url(context, '/organization/new')


@step(u'I go to dataset "{name}"')
def go_to_dataset(context, name):
    when_i_visit_url(context, '/dataset/' + name)


@step(u'I create a dataset with title "{title}" and notes "{notes}"')
def create_dataset(context, title, notes):
    context.execute_steps(u"""
        Then I go to add new dataset
        When I fill in "title" with "%s"
        When I fill in "notes" with "%s"
        When I select "False" from "private"
        When I press "save"
        Then I press the element with xpath "//form/div/div/div/a[contains(string(), "Link")]"
        When I fill in "url" with "http://example.com/test.csv"
        Then I press the element with xpath "//button[contains(string(), "Finish")]"
    """ % (title, notes))


@when('I log in')
def log_in(context):

    assert context.persona
    context.execute_steps(u"""
        When I go to homepage
        And I click the link with text that contains "Log in"
        And I fill in "login" with "$name"
        And I fill in "password" with "$password"
        And I press the element with xpath "//button[contains(string(), 'Login')]"
        Then I should see an element with xpath "//a[contains(string(), 'Log out')]"
    """)
