FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
	vim \
	curl \
	git \
	zip \
	openjdk-17-jdk \
	openjdk-11-jdk \
	tzdata \
	certbot \
	gnupg \
	&& rm -rf /var/lib/apt/lists/*
RUN ln -fs /usr/share/zoneinfo/Asia/Macau /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java \
	&& update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac \
	&& update-alternatives --set jar /usr/lib/jvm/java-17-openjdk-amd64/bin/jar
#/usr/lib/jvm/java-11-openjdk-amd64/bin/java
#/usr/lib/jvm/java-17-openjdk-amd64/bin/java

WORKDIR /opt
ARG mavenversion=3.9.6
ARG gradleversion=8.7
RUN curl "https://dlcdn.apache.org/maven/maven-3/$mavenversion/binaries/apache-maven-$mavenversion-bin.tar.gz" -o maven.tgz
RUN tar zxvf maven.tgz && rm maven.tgz
RUN curl -L "https://services.gradle.org/distributions/gradle-$gradleversion-bin.zip" -o gradle.zip
RUN unzip gradle.zip && rm gradle.zip
ENV PATH="/opt/apache-maven-$mavenversion/bin:/opt/gradle-$gradleversion/bin:${PATH}"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN source /root/.bashrc && nvm install 18 && nvm install 20
#RUN nvm -v && node -v && npm -v
SHELL ["/bin/sh", "-c"]

ARG codeserverversion=4.89.1
#curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=$codeserverversion

RUN code-server --install-extension redhat.java \
	&& code-server --install-extension vscjava.vscode-java-test \
	&& code-server --install-extension vscjava.vscode-java-debug \
	&& code-server --install-extension vscjava.vscode-maven
RUN code-server --install-extension vscjava.vscode-java-dependency
RUN code-server --install-extension ms-vscode.sublime-keybindings
RUN code-server --install-extension vue.volar
RUN code-server --install-extension redhat.fabric8-analytics
RUN code-server --install-extension redhat.vscode-xml
RUN code-server --install-extension mhutchie.git-graph

RUN mkdir /root/initExtensions/ && cd /root/.local/share/code-server/extensions/ && tar zcvf /root/initExtensions/extensions.tgz * 
RUN rm -rf /root/.local/share/code-server/extensions/*/ && rm /root/.local/share/code-server/extensions/*
RUN rm -rf /root/.cache/code-server
COPY entrypoint.sh /root/entrypoint.sh
