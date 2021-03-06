# Changelog
All notable changes to this project will be documented in this file.

## [1.3.1] - 2022-05-05
### Fixed
- Issue with newlines inside code blocks
- Shift in spaces inside code blocks
- EOF error when ending the document with a code block

## [1.3.0] - 2022-01-03
### Added
- Option `-m` to include some meta-data as variables in the output script

## [1.2.0] - 2022-01-02
### Added
- Option `-u` to self-update the **esht**
- Option `-e` to define variables in the output script

## Changed
- Removed licence details from help text

## [1.1.0] - 2021-12-28
### Added
- Option `-x` to auto-run the generated script

### Changed
- Renamed the script to just `esht` without the `.sh`

## [1.0.1] - 2021-12-26
### Fixed
- Issues with single quotes when using `dash` shell
- Unexpected behavior due to using `==` in test statements

## [1.0.0] - 2021-12-25
### Added
- Basic functionality to detect and parse `$[` and `]` tags
