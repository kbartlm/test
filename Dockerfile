FROM codenvy/shellinabox

RUN sudo apt-get update -y && \
    sudo apt-get install --no-install-recommends -y -q build-essential python3 python3-dev python-pip git python3-pip && \
    sudo pip3 install -U pip && \
    sudo pip3 install virtualenv
    
RUN sudo apt-get install -y default-jdk

ENV DEBIAN_FRONTEND noninteractive

RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list && \
    sudo apt-get update && \
    sudo -E bash -c "apt-get install -y python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 pwgen" && \
    sudo service postgresql start && \
    CODENVY_POSTGRESQL_PASSWORD=$(pwgen -N 1) && echo "export CODENVY_POSTGRESQL_PASSWORD=$CODENVY_POSTGRESQL_PASSWORD" >> /home/user/.postgresrc && \
    CODENVY_POSTGRESQL_DB=testdb_$(pwgen -N 1) && echo "export CODENVY_POSTGRESQL_DB=$CODENVY_POSTGRESQL_DB" >> /home/user/.postgresrc && \
    CODENVY_POSTGRESQL_USER=codenvy && echo "export CODENVY_POSTGRESQL_USER=$CODENVY_POSTGRESQL_USER" >> /home/user/.postgresrc && \
    sudo -u postgres psql --command "CREATE USER $CODENVY_POSTGRESQL_USER WITH SUPERUSER PASSWORD '$CODENVY_POSTGRESQL_PASSWORD';" && \
    sudo -u postgres createdb -O $CODENVY_POSTGRESQL_USER $CODENVY_POSTGRESQL_DB

ADD startup.sh /home/user/startup.sh

RUN sudo chmod +x /home/user/startup.sh

#EXPOSE 5432

CMD sudo /home/user/startup.sh
