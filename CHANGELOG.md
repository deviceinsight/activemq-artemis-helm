# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Use Github Actions for the build pipeline

## [0.6.0]
### Changed
- Removed default vromero/activemq-artemis docker image

### Fixed
- Fix generating artemis-roles.properties in order to support newer versions of Artemis

## [0.5.0] - 2020-11-23
### Added
- Add service monitor for prometheus
- mvn resource plugin to copy chart to folder not cleaned by `mvn clean` to persist old chart versions

## [0.4.0] - 2020-11-20
### Added
- git-flow plugin

### Changed
- Added possibility to specify queue names for type `topic` (multicast).

## [0.3.1] - 2020-07-08
### Added
- Include previous releases in chart repository index
- Run reduced Travis CI build when not on master

## [0.3.0] - 2020-07-07
### Added
- Integration into Travis CI
- Publish chart on GitHub pages
- Add option to configure artemis users, credentials and roles

### Fixed
- Remove namespaces from roleRef and subjects as the namespace is defined for whole RoleBinding
- Change 'empty' volume type to 'emptyDir'
- Don't log the contents of artemis-users.properties and artemis-roles.properties on startup

### Changed
- Expose prometheus service endpoint if `metrics.enabled` is `true`

## [0.2.0] - 2020-05-20
### Changed
- Add option to configure the init container image

## [0.1.2] - 2019-08-23
### Fixed
- Fixed indention of cluster secret

## [0.1.1] - 2019-08-23
### Fixed
- Fixed secret ref, if providing existing secret
- Fixed indention for resources and readiness check

## [0.1.0] - 2019-08-23
### Added
- First version of chart with support for clusters and ha with jgroups

[Unreleased]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.5.0...HEAD
[0.5.0]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.1.2...0.2.0
[0.1.2]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/deviceinsight/activemq-artemis-helm/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/deviceinsight/activemq-artemis-helm/releases/tag/0.1.0
