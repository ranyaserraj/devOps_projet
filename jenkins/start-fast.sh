#!/bin/bash

# Jenkins Fast - Script de démarrage optimisé
echo "🚀 Starting Jenkins Fast Configuration..."

# Optimisations JVM
export JAVA_OPTS="-Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -Djava.awt.headless=true"

# Optimisations Jenkins
export JENKINS_OPTS="--httpPort=8080 --prefix=/jenkins --httpListenAddress=0.0.0.0"

# Démarrer Jenkins avec optimisations
echo "⚡ Starting Jenkins with optimizations..."
exec /usr/local/bin/jenkins.sh
