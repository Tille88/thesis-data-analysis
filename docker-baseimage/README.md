If needing to update base image (e.g. after updated R-markdown file, new Latex packages or R-packages used):

1. From root of repo run
`$ docker build -t <name of image> -f docker-baseimage/Dockerfile .`
2. OPTIONAL: Maaaaaybe check interactively if working in Rstudio session on localhost:8787, standard username=rstudio, password same as input in `docker run...` below 
`$ docker run --rm --name <name of container> -p 8787:8787 -e DISABLE_AUTH=true <name of image>`
3. Get into running container (if 2 runs)
`$ docker exec -it <container ID, name of container> /bin/sh`
OR get into new container directly WITHOUT checking interactive session
`$ docker run -it <name of image> bash`
4. Get those bloody fonts in there, getting through the interactive reading and agree by writing [yes]
`$ apt-get install ttf-mscorefonts-installer`
5. From other terminal, commit the image to be used as base image for other users (TODO: insert tagging and docker account, etc.)
`$ docker commit <name of image> <new image name>`
6. push to dockerhub
`$ docker push <user/rep name>/<image>:<tag>`
7. Use image as base image (FROM baseimage) for root dockerfile ./Dockerfile
8. Of course do a tiny bit of manual testing of the expected PDF-extraction
