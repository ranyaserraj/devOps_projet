# Jenkins Dockerfile for IDURAR ERP CRM Testing
FROM jenkins/jenkins:lts

# Switch to root to install packages
USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install additional tools for testing
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages for testing
RUN pip3 install --break-system-packages requests pytest

# Switch back to jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins \
    configuration-as-code \
    docker-workflow \
    docker-plugin \
    nodejs \
    performance \
    htmlpublisher \
    junit \
    cobertura \
    git \
    github \
    github-branch-source \
    pipeline-stage-view \
    build-timeout \
    credentials-binding \
    timestamper \
    ws-cleanup \
    workflow-aggregator \
    pipeline-github-lib \
    pipeline-stage-tags-metadata \
    pipeline-utility-steps

# Set environment variables
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--httpPort=8080"
ENV CASC_JENKINS_CONFIG="/var/jenkins_home/jenkins.yaml"

# Expose Jenkins port
EXPOSE 8080

# Copy Jenkins configuration with proper ownership
USER root
COPY --chown=jenkins:jenkins jenkins.yaml /var/jenkins_home/jenkins.yaml
COPY --chown=jenkins:jenkins jobs/ /var/jenkins_home/jobs/
USER jenkins
