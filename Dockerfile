FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install vim curl git zip -y
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install tzdata -y
RUN ln -fs /usr/share/zoneinfo/Asia/Macau /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install openjdk-11-jdk -y
RUN apt-get install openjdk-17-jdk -y
RUN update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java \
	&& update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac \
	&& update-alternatives --set jar /usr/lib/jvm/java-11-openjdk-amd64/bin/jar
#/usr/lib/jvm/java-11-openjdk-amd64/bin/java
#/usr/lib/jvm/java-17-openjdk-amd64/bin/java

WORKDIR /opt
ARG mavenversion=3.8.6
ARG gradleversion=7.5.1
RUN curl "https://dlcdn.apache.org/maven/maven-3/$mavenversion/binaries/apache-maven-$mavenversion-bin.tar.gz" -o maven.tgz
RUN tar zxvf maven.tgz
RUN curl -L "https://services.gradle.org/distributions/gradle-$gradleversion-bin.zip" -o gradle.zip
RUN unzip gradle.zip
ENV PATH="/opt/apache-maven-$mavenversion/bin:/opt/gradle-$gradleversion/bin:${PATH}"

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - 
RUN apt-get install -y nodejs
RUN npm install -g npm
RUN apt-get install certbot -y

ARG codeserverversion=4.8.3
#curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=$codeserverversion

RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension ms-vscode.sublime-keybindings
RUN code-server --install-extension octref.vetur
RUN code-server --install-extension vue.volar
RUN code-server --install-extension redhat.fabric8-analytics
RUN code-server --install-extension redhat.vscode-xml
