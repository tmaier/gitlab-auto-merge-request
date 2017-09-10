# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 1.0.0 - 2017-09-10
### Added
- Add Dockerfile
- Add script from <https://rpadovani.com/open-mr-gitlab-ci>
- Add check if `$GITLAB_PRIVATE_TOKEN` is set
- Fail entire script on errors

### Changed
- Rename `$PRIVATE_TOKEN` to `$GITLAB_PRIVATE_TOKEN`
- Replace Python with [jq](https://stedolan.github.io/jq) to handle JSON
- Change `.gitlab-ci.yml`
  - Use Docker Image
  - Skip cloning git repository

[Unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/master...develop
