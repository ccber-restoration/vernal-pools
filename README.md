[![License](http://i.creativecommons.org/p/zero/1.0/88x31.png)](https://raw.githubusercontent.com/weecology/livedat/master/LICENSE)

# Notes from Francis Joyce, for Cheadle Center usage:

- You can use this template rather than https://github.com/new/import (what's in here: https://www.updatingdata.org/githubactions/copytemplate/)
- Should manually rename the .Rproj
- The basic (tutorial) version of the repository is useful for learning the basics, but for a more complex/realistic example, see https://github.com/weecology/PortalData 
- The  R-CMD-check.yaml file needs to be edited, as per https://github.com/weecology/livedat-github-actions/issues/4
- data checks (aka automated tests, "unit tests") will live in the testthat directory

# livedat with GitHub Actions

This is a **Template Repo** designed to assist in setting up a repository for regularly-updated data 
(new data are regularly added and need cleaning and curating) **using GitHub Actions** for continuous integration. This was forked from the original [Template Repo](https://github.com/weecology/livedat) **using Travis CI** for continuous integration at version 0.11.2. Read [our PLOS Biology paper](https://doi.org/10.1371/journal.pbio.3000125) for more details.

Instructions for creating an updating data workflow can be found at our companion website: 
## [UpdatingData.org/githubactions](https://www.updatingdata.org/githubactions/).

  The basic steps are:

    1. Clone the repository
    2. Configure the repository for your project
    ~~Connect to Zenodo~~
    ~~Connect to Travis~~
    5. Allow automated updating
    6. Add data code
    7. Add data
    8. Add data checks
    9. Update data
    
