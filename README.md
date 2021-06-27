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
- [ ] Simplify title
    - [ ] How is perception influenced by different display choices
- [ ] Read through and simplify text, better reading flow
- [ ] Perception is focus, start many sections with highlighting that, simplify discussion of what has been studied
- [ ] Abstract update: things on top hiding things, opacity change one of the ways to do that (problem-description)
- [ ] Section 1.1-1.2
    - [ ] Opacity/transparency definition could be included 
    - [ ] Don't start with Ware reference, describe focus in 1.1
- [ ] Fig 1 & 2 not adding much, change for own picture with different degrees of transparency
- [ ] Fig 3, more clear pictures as now very small
- [ ] Section 3, more clarity
- [ ] Fig 4, before legend design types, say multiple variants that have been tested
    - [ ] Like intro to methodology, testing 5, task basically guessing value at a specific location
- [ ] Data collection
    - [ ] Better chapter overview, describe how forms and colours generated and represented (move from Appendix), highlight not representing a physical variable but generated
- [ ] More things in methodology that can be described, could be combined(?) to 1-5 roman fig. 5. (with possibly more focus on data area)
- [ ] Fig 5 onwards
    - [ ] Add frame
    - [ ] Support lines for 0, -25, 25
- [ ] Intro text for Background-section 
- [ ] Fig 5 & table 2 (also describing text) -> Results, only methodology saying what will be done 
- [ ] Research questions more concrete (tighten up slightly)
    - [ ] web based investigation
- [ ] Discussion section, start with introduction sentences as some may not have seen results but skipping sections
    - [ ] “This type” = transparency types
    - [ ] We see => it is evident
    - [ ] Lower variance of what…
    - [ ] "Strongest" = significance? Most robust no matter how results and subsetting done
    - [ ] More difficult to estimate value from the colour if value only in tittle, no comparison possible.
    - [ ] Can highlight what makes people use web interface a bit unexpected


- [ ] "Magnitude" of estimates discussion, statistically significant to (degree 95% and similar)
- [ ] Color graphs for BW print
- [ ] Last TODOs in Rmarkdown file
- [ ] Remove POP-abstract & change standard Abstract PDF -> generated
- [ ] AGAIN: Read through and simplify text
