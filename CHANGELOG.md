# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- Remove namespaces from roleRef and subjects as the namespace is defined for whole RoleBinding
- Change 'empty' volume type to 'emptyDir'

## [0.2.0] - 2020-05-20
### Changed
- Add option to configure the init container image
- Expose prometheus service endpoint if `metrics.enabled` is `true`

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
