# Open GitLab Merge Requests automatically

[![Docker Automated buil](https://img.shields.io/docker/automated/tmaier/gitlab-auto-merge-request.svg)](https://hub.docker.com/r/tmaier/gitlab-auto-merge-request/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tmaier/gitlab-auto-merge-request.svg)](https://hub.docker.com/r/tmaier/gitlab-auto-merge-request/)

This script is meant to be used in GitLab CI to automatically open Merge Requests for feature branches, if there is none yet.

The script is provided as dedicated docker image to improve maintainability in the future.

It is based on the script and idea of [Riccardo Padovani](https://rpadovani.com), which he introduced with his blog post [How to automatically create new MR on Gitlab with Gitlab CI](https://rpadovani.com/open-mr-gitlab-ci).
Thanks for providing this.

## Instructions

Add the following to your `.gitlab-ci.yml` file:

```yaml
stages:
  - openMr
  - otherStages

openMr:
  image: tmaier/gitlab-auto-merge-request
  before_script: [] # We do not need any setup work, let's remove the global one (if any)
  variables:
    GIT_STRATEGY: none # We do not need a clone of the GIT repository to create a Merge Request
  stage: openMr
  only:
    - /^feature\/*/ # We have a very strict naming convention
  script:
    - ./merge-request.sh # The name of the script
```

Set a secret variable in your GitLab project with your private token.
Name it `GITLAB_PRIVATE_TOKEN`.
This is necessary to raise the Merge Request on your behalf.

## This project is managed on GitLab

The [GitHub project][] is only a mirror of the [GitLab project][].

[GitHub project]: https://github.com/tmaier/gitlab-auto-merge-request
[GitLab project]: https://gitlab.com/tmaier/gitlab-auto-merge-request

Please open Issues and Merge Requests at the [GitLab project][].

## Authors

* Docker part: [Tobias L. Maier](http://tobiasmaier.info)
* Script and idea: [Riccardo Padovani](https://rpadovani.com)
