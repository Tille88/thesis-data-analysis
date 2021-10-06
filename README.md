# thesis-data-analysis

## Build docker image

From root of repository run

```bash
docker build -t thesis-local .
```

## Example usages (after image built):

### Open interactive Rstudio setting

```bash
docker run -it --rm -e DISABLE_AUTH=true -p 8787:8787 thesis-local
```

Then open `http://localhost:8787/` in your browser.

You can open the file `./thesis-writeup/thesis-writeup.Rmd` and press the "knit" button, and it should generate a PDF.

Alternatively, you can open `./thesis-writeup/load_data_for_interactive.R`, and work with the data

### Generate PDF-output to local folder

Run the command below from root of repository. The file should end up in `./pdf-output`

```bash
docker run -it --rm -v $PWD/pdf-output:/home/rstudio/pdf-output thesis-local Rscript -e "rmarkdown::render('./thesis-writeup/thesis-writeup.Rmd', output_file = 'tillman_thesis.pdf', output_dir = './pdf-output')"
```

### Work in R from command line

```r
$ docker run -it --rm  thesis-local R
R version 4.0.4 (2021-02-15) -- "Lost Library Book"
Copyright (C) 2021 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)
R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.
R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.
Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.
> source("./thesis-writeup/load_data_for_interactive.R")
> ls()
[1] "acceptancessdf"      "acceptancessdf_long" "clean_df"
[4] "hover_df"            "progressiondf"       "respondentdf"
[7] "responsesdf"         "slider_df"
```

## Raw and semi-processed data

Raw data exists in the data frames

- acceptancessdf / acceptancessdf_long (long format)    
- progressiondf  
- respondentdf 
- responsesdf

Specific event data in the data frames
- hover_df
- slider_df

And clean data for start of thesis analysis in
- clean_df

## TODOs
- [x] Remove POP-abstract & change standard Abstract PDF -> generated
- [x] Simplify title
    - [x] How is perception influenced by different display choices
- [x] Fig 1 & 2 not adding much, change for own picture with different degrees of transparency
- [x] Fig 3, more clear pictures as now very small
- [x] Fig 5 onwards
    - [x] Add frame
    - [x] Slightly smaller
- [x] Abstract update: things on top hiding things, opacity change one of the ways to do that (problem-description)
- [x] Fig 4
    - [x] Make special version showing legend w less empty space (more focus data area)
    - [x] 2 sections (baselines) + alternatives
    - [x] Move before legend design types description
- [x] Section 1.1-1.2
    - [x] Opacity/transparency definition could be included 
    - [x] Don't start with Ware reference, describe focus in 1.1
- [x] Research questions more concrete (tighten up slightly)
    - [x] web based investigation
- [x] Discussion section, start with introduction sentences as some may not have seen results but skipping sections
    - [x] “This type” = transparency types
    - [x] We see => it is evident
    - [x] Lower variance of what…
    - [x] "Strongest" = significance? Most robust no matter how results and subsetting done
    - [x] More difficult to estimate value from the colour if value only in tittle, no comparison possible.
    - [x] Can highlight what makes people use web interface a bit unexpected
- [x] Intro text for Background-section 


- [x] Section 3 (METHODOLOGY), more clarity
    - [x] Inline notes in thesis PDF (40309401_giv15jti_GISM01_2900-28.pdf)
    - [x] Say multiple variants that have been tested
        - [x] Like intro to methodology, testing 5, task basically guessing value at a specific location
    - [x] More things in methodology that can be described, could be combined(?) to 1-5 roman fig. 4.
    - [x] Data collection
        - [x] Better chapter overview, describe how forms and colours generated and represented (move from Appendix), highlight not representing a physical variable but generated
    - [x] Change references to Appendix A-C....
    - [x] Fig 5 & table 2 (also describing text) -> Results, only methodology saying what will be done 
- [x] Include examples of blue/red/green figure


- [x] PRINT -> Read through and simplify text, better reading flow
    - [x] Perception is focus, start many sections with highlighting that, simplify discussion of what has been studied

<!-- Pre secondary draft -->
- [x] AGAIN: Print + read through and simplify text
- [x] Grammarly
- [x] Use speech to text-read through full thesis
- [x] Make clear 4 legends and 1 non-legend (minimum information for task) throughout

<!-- Pre third draft -->
- [x] Add front page
- [x] Larger fig 6
- [x] Add abbreviations
- [x] References before appendix
- [x] Numbering of pages check
- [x] Fixes abstract
- [x] Footnotes check through
- [ ] Discussion/conclusions
    - [x] Remove paragraph that should not be part of discussion
    - [x] Rename to also include conclusions
    - [x] Research questions explicitly listed (1-4)
    - [ ] Close of discussion

Nästa steg:
- [ ] Check all numbering correct, figures/tables in correct place, etc. before submitting
- [ ] Read through conclusions thoroughly, make sure has a good flow
- [ ] Check notes application for how to flag to department admin
