FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install vim curl git -y
#curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.1.0
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=ASIA/MACAU
RUN apt-get install tzdata -y
RUN apt-get install openjdk-11-jdk -y
WORKDIR /opt
RUN curl https://downloads.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz -o maven.tgz
RUN tar zxvf maven.tgz
ENV PATH="/opt/apache-maven-3.8.5/bin:${PATH}"

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - 
RUN apt-get install -y nodejs
RUN npm install -g npm
RUN apt-get install certbot -y

RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension afmicc.getterandsettergenerator
RUN code-server --install-extension ms-vscode.sublime-keybindings
RUN code-server --install-extension octref.vetur
RUN code-server --install-extension wmaurer.change-case
