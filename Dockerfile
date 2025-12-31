FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG mavenversion=3.9.12
ARG gradleversion=9.2.1
ARG nvmversion=v0.40.3
ARG codeserverversion=4.107.0

RUN apt-get update && apt-get install -y \
	vim \
	curl \
	git \
	zip \
	openjdk-8-jdk \
	openjdk-17-jdk \
	openjdk-21-jdk \
	tzdata \
	sudo \
	&& rm -rf /var/lib/apt/lists/*
RUN ln -fs /usr/share/zoneinfo/Asia/Macau /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java \
	&& update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac \
	&& update-alternatives --set jar /usr/lib/jvm/java-21-openjdk-amd64/bin/jar
#/usr/lib/jvm/java-17-openjdk-amd64/bin/java

WORKDIR /opt
RUN curl "https://dlcdn.apache.org/maven/maven-3/$mavenversion/binaries/apache-maven-$mavenversion-bin.tar.gz" -o maven.tgz \
	&& tar zxvf maven.tgz && rm maven.tgz \
	&& curl -L "https://services.gradle.org/distributions/gradle-$gradleversion-bin.zip" -o gradle.zip \
	&& unzip gradle.zip && rm gradle.zip

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/ubuntu
USER ubuntu
WORKDIR /home/ubuntu
ENV PATH="/opt/apache-maven-$mavenversion/bin:/opt/gradle-$gradleversion/bin:${PATH}"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$nvmversion/install.sh | bash
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN source /home/ubuntu/.bashrc && nvm install 22 && nvm install 20
#RUN nvm -v && node -v && npm -v
SHELL ["/bin/sh", "-c"]

#curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=$codeserverversion

RUN code-server --install-extension redhat.java \
	&& code-server --install-extension vscjava.vscode-java-test \
	&& code-server --install-extension vscjava.vscode-java-debug \
	#&& code-server --install-extension vscjava.vscode-java-debug@0.58.2 \
	&& code-server --install-extension vscjava.vscode-maven \
	&& code-server --install-extension vscjava.vscode-java-dependency \
	&& code-server --install-extension ms-vscode.sublime-keybindings \
	&& code-server --install-extension vue.volar \
	&& code-server --install-extension redhat.fabric8-analytics \
	&& code-server --install-extension redhat.vscode-xml \
	&& code-server --install-extension mhutchie.git-graph \
	&& mkdir /home/ubuntu/initExtensions/ \
	&& cd /home/ubuntu/.local/share/code-server/extensions/ \
	&& tar zcvf /home/ubuntu/initExtensions/extensions.tgz * \
	&& rm -rf /home/ubuntu/.local/share/code-server/extensions/ \
	&& rm -rf /home/ubuntu/.cache/code-server

COPY entrypoint.sh /home/ubuntu/entrypoint.sh
# set defualt permission so that new mounted volume folder owner is ubuntu
RUN mkdir /home/ubuntu/.m2 && mkdir /home/ubuntu/sourcecode && mkdir /home/ubuntu/.local/share/code-server/extensions
