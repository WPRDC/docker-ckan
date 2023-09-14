## Docker References
https://docs.docker.com/engine/reference/builder/
https://docs.docker.com/compose/compose-file/


## Compose files
Current we have two compose files that define different deployment styles; Develop using `docker-compoes.dev.yaml` and production using `docker-compose.yaml`.

These are the starting point for defining our deployments.  These files specify which `DockerFile`s and `.env` files are used.  The `DockerFile`s will specify what other start up scripts are run. 

## Services

Each service has it's own directory in which it's configured.  
Solr doesn't have a directory since we use the provided image.

### CKAN

Our custom configuration is defined in [`ckan/`](ckan/). This is where we define the addition and changes we want made
to the base image.

The[`ckan-base/`](ckan-base/) and [`ckan-dev/`](ckan-dev/) directories hold source code for the base builds from OKFN. 
OKFN hosts images built from these on Docker registry.
Changes to these directories are pulled from [the OKFN remote](https://github.com/okfn/docker-ckan).
Any changes made to these directories should be done on a separate branch intended for a pull request the remote.
When we build our `CKAN` images the are built on top of the respective prebuilt `CKAN` image from the Docker repository.

#### Startup scripts

Scripts copied to `/docker-entrypoint.d/` will be run, in alphabetical order, when the container starts.

[`docker-entrypoint.d`](ckan/docker-entrypoint.d) - copied when using Dockerfile  
[`docker-entrypoint.d.dev`](ckan/docker-entrypoint.d.dev) - copied when using Dockerfile.dev  
[`fixtures`](ckan/fixtures) - dumps of data used to prepopulate the database in development builds  
[`patches`](ckan/patches) - patches to apply to the CKAN source code installed on the image. (
see [README.md](/README.md) for me information)

### Datapusher Plus
Docker configuration based on https://github.com/dathere/datapusher-plus-docker

### PostgreSQL
Not used in production.  Defines build for postgres db. Has startup scripts to set up db for CKAN and Datapusher+.

### Solr
Uses this prebuilt SOLR image made for CKAN by CKAN: https://registry.hub.docker.com/r/ckan/ckan-solr.


## Useful Commands
### Build and deploy using docker compose

```shell
# all instances
docker compose up --build -d   

# all instances but for the dev setup
docker compose up -f docker-compose.dev.yaml --build -d   

# a single instance
docker compose up --build -d <service_name>
```

### See list of containers
```shell
docker ps
```

### Start a bash session inside the container created for the ckan session (happens to be named 'ckan' as well)
```shell
docker exec -it ckan bash # can also use 'docker ps' to list all to find a container ID. Ours our specified in our docker-compose file.
```

### Run a command inside the container from the host (how you'll likely want to run commands in cron)
```shell
docker exec -it ckan 'your arbitrary command here'
```


### Developing the theme
Clone https://github.com/WPRDC/ckanext-wprdctheme into the `src` directory. 
Deploying using `docker-compose.dev.yaml`, will require this to be done as it looks for our theme there.  
Any changes made to our theme will automatically be applied when using the dev deployment.


### Publishing change to the theme
1. Commit your changes to the `main` branch of the [theme repo](https://github.com/WPRDC/ckanext-wprdctheme)
2. Rebuild and redeploy (`... --build -d ckan`) the `ckan` service on the production server.  Rebuilding should require it to pull in the latest version of the theme form github.
3. If the changes don't show up, try first rebuilding it without using the docker cache and then deploying it.
```shell
docker compose build --no-cache ckan 
docker compose up -d ckan 
```