Wither
======

Overview
--------

Wither uses Cucumber to check that a project in Redmine conforms to
a given development process. It builds on a short
[blog post](http://mangled.me/blog/2012/07/22/jenkins-redmine-tool-for-team-process-conformity-checking/)
I wrote a while back on this topic.

I needed this tool as Redmine is limited in its ability to enforce
/restrict workflow and/or check a project is following process
constraints.

This tool will integrate with Jenkins, allowing routine conformity checks
to be made. You will need to configure Jenkins to parse Cucumber reports.

Here is an example of a feature for checking new tickets:

```
Feature: new issues
  In order to triage a ticket
  As a developer
  I want all new tickets to be in a valid state

  Background:
    Given issues with a status of New
    And none in target version Future

  Scenario: the source field must be set
    When i check the source field
    Then the source field must be one of the following:
    |value          |
    |Somewhere      |

    Scenario: tickets must be triaged often
      When i check how long a ticket has been waiting
      Then the waiting time should not exceed "3" days
```

When executed this would check that all "new" tickets are assigned a valid "source" field. Also, that a "new" ticket hasn't been sitting around unattended for more than three days.

Usage
-----

The tool was written for a project I was working on which concluded
late 2015 - It was _never intended to be generic_ but would with a few tweaks be use-able in any project that has the same needs.

With the given caveats above, I will provide some *tips* on getting this working. As discussed, if you are genuinely interested, then e-mail me and I will walk through this in more detail.

I ran this on ruby `ruby 2.3.1p112`, pull the code from GitHub and:

```
$ gem install bundler
$ bundle install
```

Look at `support/config.yml`, adjust the URL and fill in a valid Redmine API key - See the Redmine documentation for information on where to get access to this information.

You will notice that it defines two variables `parent_project_id` and `sub_project_id` - These are used in `redmine.rb` the function `Redmine.issues(...)` this is due to the project I worked on having a nested hierarchy, so I needed to pull in tickets from a parent and sub-project. You may not need this, adjust as desired.

As an aside, in `hooks.rb` there is a debugging option `USE_DUMP_FILE_FOR_DEBUGGING` which will pull the Redmine tickets locally as a `.json` file and use it for queries - This speeds up testing.

To run the tool and generate a report, `cucumber --tags ~@ignore -f html -o report.html`

One thing to note about this tool, it bends Cucumber slightly, in that it checks across "n" items for failures and builds a log of all items which fail in the "then" clause. This is so I can see all tickets which fail for a given scenario.

Help!
-----

If you find the concept interesting please contact me
[MangledMe](http://www.google.com/recaptcha/mailhide/d?k=01vdgNNADQlgrqj5lMuKLpag==&c=dLzYSFd6PdPBc5paL9eJKJ62wOQODVZwCaNzqvMcxyI=)
and I will help get you up and running or provide some more detail.
