FROM codenvy/shellinabox

RUN sudo apt-get update -y && \
    sudo apt-get install --no-install-recommends -y -q build-essential python3 python3-dev python-pip git python3-pip && \
    sudo pip3 install -U pip && \
    sudo pip3 install virtualenv
    
RUN wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    -qO- \
    "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz" | sudo tar -zx -C /opt/
     
ENV JAVA_HOME /opt/jdk1.7.0_55
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /home/user/.bashrc
ENV PATH $JAVA_HOME/bin:$PATH
RUN echo "export PATH=$PATH" >> /home/user/.bashrc

sudo apt-get install -y g++ python3-dev
