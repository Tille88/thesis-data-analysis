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
- [x] Discussion/conclusions
    - [x] Remove paragraph that should not be part of discussion
    - [x] Rename to also include conclusions
    - [x] Research questions explicitly listed (1-4)
    - [x] Close of discussion
        - [x] Check place for "size questioned"
        - [x] Check old commits for references to cite (context not proven...)
        - [x] Put into larger context

Nästa steg:
- [x] (Scroll through) - Check all numbering correct, figures/tables in correct place, etc. before submitting
- [x] Read through conclusions thoroughly, make sure has a good flow
- [x] Check notes application for how to flag to department admin


<!-- Post defense updates -->
- [ ] Check paper notes if any below not included

**Lars comments**
- [ ] See scanned comments (List here, screenshots into Pages update document under right section)
- [ ] Describe test persons (see example in HARRIE, L., 2017, attached)
- [ ] Theory-section extended, e.g. about colour based studies
    - [ ] Check articles (and references in them)
    - [ ] User study example + hatches option (see example in HARRIE, L., 2017, attached)
    - [ ] Stefan Seipel, et al. 
        - Visualization of 3D Property Data and Assessment of the Impact of Rendering Attributes (check references)
    - [ ] Bring in Brewer again?
    - [ ] Check if can find:
        - [x] Brychtova, A. and Coltekin, A. (2015). ‘An empirical user study for measuring the influence of colour distance and font size in map reading using eye tracking’, The Cartographic Journal, in print.
        - [x] Coltekin, A., Heil, B., Garlandini, S. and Fabrikant, S. I. (2009). ‘Evaluating the effectiveness of interactive map interface designs: a case study integrating usability metrics with eye-movement analysis’,
        - [x] Bunch, R. L. and Lloyd, R. E. (2006). ‘The cognitive load of geographic information’, The Professional Geographer, 58(2), pp. 209–220. Cartography and Geographic Information Science, 36(1), pp. 5–17.
        - [x] Dong, W., Liao, H., Roth, R. E. and Wang, S. (2014). ‘Eye tracking to explore the potential of enhanced imagery basemaps in web mapping’, The Cartographic Journal, 51(4), pp. 313–329.
        - [x] Ooms, K., De Maeyer, P., Fack, V., Van Assche, E. and Witlox, F. (2012a). ‘Investigating the effectiveness of an efficient label placement method using eye movement data’, Cartographic Journal, 49 (3), pp. 234–246.
        - [x] Ooms, K., De Maeyer, P. and Fack, V. (2015). ‘Listen to the map user: cognition, memory, and expertise’, The Cartographic Journal, 52(1), pp. 3–19.
        - [x] Montello, D. R. (2002). ‘Cognitive map-design research in the twentieth century: theoretical and empirical approaches’, Cartography and Geographic Information Science, 29(3), pp. 283–304.
        - [x] Aerts JCJH, Clarke KC, Keuper AD (2003) Testing popular visualization techniques for representing model uncertainty. Cartogr Geogr Inf Sci 30(3):249–261
        - [x] Burt JE, Zhu AX, Harrower M (2011) Depicting classification uncertainty using perception based color models. Ann GIS 17(3):147–153
        - [x] Carnec M, Le Callet P, Barba D (2008) Objective quality assessment of color images based on a generic perceptual reduced reference. Signal Process Image Commun 23(4):239–256
        - [x] Cheong L, Bleisch S, Kealy A, Tolhurst K, Wilkening T, Duckham M (2016) Evaluating the impact of visualization of wildfire hazard upon decisionmaking under uncertainty. Int J Geogr Inf Sci 30(7):1377–1404
        - [x] Itti L, Koch C (2001) Computational modelling of visual attention. Nat Rev Neurosci 2(3):194–203
        - [x] Kikuchi H, Kataoka S, Muramatsu S, Huttunen H (2013) Color-tone similarity of digital images. Proceedings 2013 IEEE International Conference on Image Processing, ICIP https://doi.org/10.1109/ ICIP.2013.6738081
        - [x] Matzen LE, Haass MJ, Divis KM, Wang Z, Wilson AT (2017) Data visualization saliency model: a tool for evaluating abstract data visualizations. IEEE Trans Vis Comput Graph 24(1):563–573
        - [x] Parkhurst D, Law K, Niebur E (2002) Modeling the role of salience in the allocation of overt visual attention. Vis Res 42(1):107–123
        - [x] Seipel S, Lim NJ (2017) Color map design for visualization in flood risk assessment. Int J Geogr Inf Sci 31(11):2286–2309
        - [x] Leitner M, Buttenfield BP (2000) Guidelines for the display of attribute certainty. Cartogr Geogr Inf Sci 27(1):3–14
        - [x] Wall E, Arcalgud A, Gupta K, Jo A (2019) A Markov model of users’ interactive behavior in scatterplots, visualization conference (VIS) 2019 IEEE, pp. 81–85
        - [x] Milosavljevic M, Navalpakkam V, Koch C, Rangel A (2012) Relative visual saliency differences induce sizable bias in consumer choice. J Consum Psychol 22(1):67–74
        - [x] Stricker M, Orengo M (1995) Similarity of color images. Proc. SPIE 2420, storage and retrieval for image and video databases III, The International Society for Optical Engineering. pp. 381-392
        - [x] Underwood T, Foulsham T, van Loon E, Humphreys L, Bloyce J (2006) Eye movements during scene inspection: a test of the saliency map hypothesis. Eur J Cogn Psychol 18(3):321–342
        - [x] van den Branden Lambrecht CJ, Farrell JE (1996) Perceptual quality metric for digitally coded color images. Proceedings 1996 8th European Signal Processing Conference (EUSIPCO 1996), Trieste, Italy, 1996, pp. 1–4
        - [x] Wang C, Pouliot J, Hubert F (2016) How users perceive transparency in the 3D visualization of cadastre: testing its usability in an online questionnaire. GeoInformatica. 21:599–618. https://doi.org/10.1007/s10707-016-0281-y
        - [x] Zhang X (2009) A novel quality metric for image fusion based on color and structural similarity. Proceedings 2009 International Conference on Signal Processing Systems, Singapore, 2009, pp. 258-262, https://doi.org/10.1109/ICSPS.2009.72







**Helena's comments**
- [ ] Present in the introduction that this is a user-study and what this means. Involve the reader on what a user-study is, how it is/could be constructed, and argue for your own way of dealing with issues connected to user studies. Relate to what you learned in Research Methodology.
- [ ] In the background/methods: 
    - [ ] also describe and motive/argue for the form of the questionnaire that you did. Why 10 questions? Exactly what and how did you randomise these questions! Why did you have the respondents answer the way you did (5 alternatives)? Doesn't have to be long, but a paragraph or 2 at least.
    - [ ] The users, describe them, such as if there a certain target group that this study applies to and if so, how. About the users, try to comment on how they are distributed regarding properties such as: 
        - [ ] Are they randomly picked (are they supposed to represent a population), are they a focus group (seems more likely), what defines this focus group and why did you choose them? 
        - [ ] Are they working with maps in their jobs? Why did you choose them?
        - [ ] Why 34 respondents? Is this a suitable size of your sampling group? How come?
        - [ ] Do the respondents share other aspects? How about age/colour blindness/sex/educational background/background in map-making/reading/other?
- [ ] Insert a separate chapter for the discussion and a separate for the conclusions. The conclusions could be ½ to 1 page and preferably in 1 paragraph. Here you only claim how each of the RQ were solved (if they were solved).
- [ ] Discussion: 
    - [ ] Skip the fst paragraph. Never repeat what you did or the the intention with the study in the discussion. This is a very very common mistake.
    - [ ] Some part of the discussion would be better suited in the Methodology section, such as the settings/considerations that you did (the bulleted list). 
    - [ ] Make sure that you "take care" of aspects that you introduce/describe in the background and methods sections. Compare your method/results to studies/theories that you describe in the first par of your study (anything before the Results chapter). 
    - [ ] Future perspective: 
        - [ ] suggest improvements and/or developments. For instance my suggestion to link accuracy (RQ2) with performance (RQ3). Did the respondents that preferred a certain legend actually perform better when they were given examples where the legend that they preferred was used? 
        - [ ] How could the time/hesitation perspective be taken cared of? Propose a methodology where the last RQ would have been more reliable.
- [ ] Why not inserting an example of how the questionnaire could look for a user, both the intro, and each of the questions.
- [ ] A last thought: During the presentation, you told us that you tested if the different colours had any effect on the accuracy, and it didn't, so you didn't present anything about this in your study. However, a "no correlation" is also an important result. If possible, I would suggest you to implement the outcome of your results in your study, especially since Lars suggests you to provide more background material on this issue.

