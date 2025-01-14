FROM openknowledge/ckan-base:2.10

MAINTAINER Western Pennsylvania Regional Data Center <wprdc@pitt.edu>

# Set timezone
ARG TZ
RUN echo $TZ > /etc/timezone
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime

# Install extensions
### DCAT ###
RUN  pip3 install -e git+https://github.com/ckan/ckanext-dcat.git#egg=ckanext-dcat && \
     pip3 install -r ${APP_DIR}/src/ckanext-dcat/requirements.txt

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

### Hierarchy ###
RUN pip3 install -e "git+https://github.com/davidread/ckanext-hierarchy.git#egg=ckanext-hierarchy" && \
    pip3 install -r ${APP_DIR}/src/ckanext-hierarchy/requirements.txt
### Scheming ###
RUN  pip3 install -e 'git+https://github.com/ckan/ckanext-scheming.git@master#egg=ckanext-scheming'

### PDF View ###
RUN pip3 install ckanext-pdfview

### Geoview ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-geoview.git#egg=ckanext-geoview

### Office Docs ###
RUN pip3 install -e git+https://github.com/jqnatividad/ckanext-officedocs.git#egg=ckanext-officedocs

### Featured Views ###
RUN pip3 install -e git+https://github.com/OpenGov-OpenData/ckanext-featuredviews.git#egg=ckanext-featuredviews

### DataJSON ###
### TODO: fork this repo and update it to work with 2.10
RUN pip3 install -e git+https://github.com/GSA/ckanext-datajson.git#egg=ckanext-datajson && \
    pip3 install -r ${APP_DIR}/src/ckanext-datajson/requirements.txt

### Report ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-report.git#egg=ckanext-report

### Fluent ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-fluent.git#egg=ckanext-fluent && \
    pip3 install -r ${APP_DIR}/src/ckanext-fluent/requirements.txt

# Install Theme
RUN pip install -e git+https://github.com/wprdc/ckanext-wprdctheme.git#egg=ckanext-wprdctheme


# Storage permissions
RUN mkdir -p /var/lib/ckan/uploads

RUN sudo chown -R ckan:ckan /var/lib/ckan/uploads
RUN sudo chmod u+rwx /var/lib/ckan

# Storage permissions
RUN sudo chown -R ckan:ckan /var/lib/ckan
RUN sudo chmod u+rwx /var/lib/ckan

# Custom scripts to run on start
COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
# See https://github.com/okfn/docker-ckan#applying-patches
COPY patches ${APP_DIR}/patches

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
