# Open GitLab Merge Requests automatically

This script is meant to be used in GitLab CI to automatically open Merge Requests for feature branches, if there is none yet.

The script is provided as dedicated docker image to improve maintainability in the future.

It is based on the script and idea of [Riccardo Padovani](https://rpadovani.com), which he introduced at <https://rpadovani.com/open-mr-gitlab-ci>.
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
  stage: openMr
  only:
    - /^feature\/*/   # We have a very strict naming convention
  script:
    - ./merge-request.sh # The name of the script
```

## Authors

* Docker part: [Tobias L. Maier](http://tobiasmaier.info)
* Script and idea: [Riccardo Padovani](https://rpadovani.com)
