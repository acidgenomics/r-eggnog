## EggNOG 0.3.1 (2025-05-25)

Maintenance release.

Minor changes:

- Reverted R minimum dependency to 4.0 for better backward compatibility on
  legacy systems.
- Now using air for automatic formatting.

## EggNOG 0.3.0 (2023-10-06)

Major changes:

- Bumping version due to significant changes in Acid Genomics dependency
  packages.
- Migrated release-specific checks to longtests.
- Acid Genomics imports now use strict camel case formatting.

## EggNOG 0.2.2 (2023-08-11)

Minor changes:

- Now requiring R 4.3 / Bioconductor 3.17.
- Updated lintr checks.
- Now running testthat unit tests in parallel.

## EggNOG 0.2.1 (2023-05-19)

Minor changes:

- Fix for breaking change with `import` using `con` instead of `file` as the
  primary input argument.

## EggNOG 0.2.0 (2022-06-08)

Major changes:

- Now requiring R 4.2 / Bioconductor 3.15.
- Updated package to support EggNOG 5.0 database annotations.

## EggNOG 0.1.4 (2021-03-12)

Minor changes:

- Updated basejump dependencies, eliminating requirement for importing stringr.

## EggNOG 0.1.3 (2021-02-21)

Minor changes:

- Maintenance release, supporting EggNOG 4.5 and 4.1.
- Support for new EggNOG 5 release is in development.

## EggNOG 0.1.2 (2020-10-13)

Minor changes:

- Maintenance release, updating basejump dependencies.

## EggNOG 0.1.1 (2020-07-23)

Minor changes:

- Maintenance release, bumping R requirement to 4.0.

## EggNOG 0.1.0 (2019-08-27)

Initial release.
