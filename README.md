# Overview

- The purpose of this repository is to work with vernal pool depth data. Vernal pools are monitored weekly during the wet season using a Survey123 Form ("CCBER Vernal Pool Hydrology")
- This repository is also an experiment with using the approach to continuous integration (working with data that are regularly updated) outlined by this webpage: https://www.updatingdata.org/

## Data usage notes
- Each row should represent the water depth for a specific vernal pool at a particular timepoint
- **Location** indicates the general area where a vernal pool is located (e.g. "Del Sol & Camino Corto"). This field is based on a drop-down menu so the values are standardized (clean)
- **Vernal Pool Name or ID** should be the unique identifier for each vernal pool. The form does not currently include any validation for this field, so cleaning is required.
 - Not sure yet whether these align with the codes in Tang et al. 2023 (69 pools, see supplement: https://doi.org/10.1111/rec.13991) 
- **Water level** is recorded in inches (FJ- it looks like the precision is to the nearest 0.25 inches based on a staff gauge). There are sometimes issues with the staff gauge being damaged, or with sedimentation/vegetation accumulating on the bottom of the pool.
- The comments field contains information on vernal pool conditions and monitoring irregularities. "Note any observations of interest about the vernal pool, such as appearance or condition of native or weed plants, wildlife, etc. (optional - include a photo in the box below)."
-  Survey123 automatically records geographic coordinates based on the device (tablet or smartphone) gps. This means that every row has a slightly different recorded location, and in some cases the location recorded does not correspond to the vernal pool location, and instead to wherever the monitor was when entering data.
- 
 

# Notes related to the Updating Data set-up

# Notes from Francis Joyce, for Cheadle Center usage:

- You can use this template rather than https://github.com/new/import (what's in here: https://www.updatingdata.org/githubactions/copytemplate/)
- Should manually rename the .Rproj
- Run usethis::use_github_action() rather than usethis::use_github_actions(), which has been deprecated
- The basic (tutorial) version of the repository is useful for learning the basics, but for a more complex/realistic example, see https://github.com/weecology/PortalData 
- The  R-CMD-check.yaml file needs to be edited, as per https://github.com/weecology/livedat-github-actions/issues/4
- data checks (aka automated tests, "unit tests") will live in the testthat directory

# Notes from the template:

# livedat with GitHub Actions

[![License](http://i.creativecommons.org/p/zero/1.0/88x31.png)](https://raw.githubusercontent.com/weecology/livedat/master/LICENSE)



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
    
