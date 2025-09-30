#!/bin/bash

# Script de déploiement optimisé pour IDURAR ERP CRM
# Usage: ./deploy-optimized.sh [start|stop|restart|logs|status]

set -e

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier les prérequis
check_prerequisites() {
    log "Vérification des prérequis..."
    
    if ! command -v docker &> /dev/null; then
        error "Docker n'est pas installé"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose n'est pas installé"
        exit 1
    fi
    
    # Vérifier l'espace disque
    available_space=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available_space" -lt 5 ]; then
        warning "Espace disque faible: ${available_space}G disponible"
    fi
    
    success "Prérequis vérifiés"
}

# Nettoyer les ressources Docker
cleanup() {
    log "Nettoyage des ressources Docker..."
    
    # Arrêter les conteneurs existants
    docker-compose -f docker-compose-optimized.yml down --remove-orphans 2>/dev/null || true
    
    # Nettoyer les images inutilisées
    docker image prune -f
    
    # Nettoyer les volumes inutilisés
    docker volume prune -f
    
    success "Nettoyage terminé"
}

# Construire les images optimisées
build_images() {
    log "Construction des images optimisées..."
    
    # Build avec cache et optimisations
    docker-compose -f docker-compose-optimized.yml build --no-cache --parallel
    
    success "Images construites avec succès"
}

# Démarrer les services
start_services() {
    log "Démarrage des services optimisés..."
    
    # Créer le répertoire de données MongoDB
    mkdir -p ./data/mongodb
    
    # Démarrer les services
    docker-compose -f docker-compose-optimized.yml up -d
    
    # Attendre que les services soient prêts
    log "Attente du démarrage des services..."
    sleep 30
    
    # Vérifier le statut des services
    check_services_health
    
    success "Services démarrés avec succès"
}

# Vérifier la santé des services
check_services_health() {
    log "Vérification de la santé des services..."
    
    # MongoDB
    if docker-compose -f docker-compose-optimized.yml exec -T mongodb mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        success "MongoDB: OK"
    else
        error "MongoDB: KO"
        return 1
    fi
    
    # Backend
    if curl -f http://localhost:5002/api/health > /dev/null 2>&1; then
        success "Backend: OK"
    else
        error "Backend: KO"
        return 1
    fi
    
    # Frontend
    if curl -f http://localhost:3001/ > /dev/null 2>&1; then
        success "Frontend: OK"
    else
        error "Frontend: KO"
        return 1
    fi
    
    # Monitoring
    if curl -f http://localhost:9100/metrics > /dev/null 2>&1; then
        success "Monitoring: OK"
    else
        warning "Monitoring: KO (optionnel)"
    fi
}

# Afficher les logs
show_logs() {
    log "Affichage des logs des services..."
    docker-compose -f docker-compose-optimized.yml logs -f --tail=100
}

# Afficher le statut
show_status() {
    log "Statut des services:"
    docker-compose -f docker-compose-optimized.yml ps
    
    echo ""
    log "Utilisation des ressources:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# Arrêter les services
stop_services() {
    log "Arrêt des services..."
    docker-compose -f docker-compose-optimized.yml down
    success "Services arrêtés"
}

# Redémarrer les services
restart_services() {
    log "Redémarrage des services..."
    stop_services
    start_services
}

# Afficher l'aide
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Démarrer les services optimisés"
    echo "  stop      Arrêter les services"
    echo "  restart   Redémarrer les services"
    echo "  logs      Afficher les logs"
    echo "  status    Afficher le statut des services"
    echo "  health    Vérifier la santé des services"
    echo "  cleanup   Nettoyer les ressources Docker"
    echo "  help      Afficher cette aide"
    echo ""
    echo "Services disponibles:"
    echo "  - Frontend: http://localhost:3001"
    echo "  - Backend:  http://localhost:5002"
    echo "  - MongoDB:  localhost:27018"
    echo "  - Monitoring: http://localhost:9100"
}

# Fonction principale
main() {
    case "${1:-help}" in
        start)
            check_prerequisites
            cleanup
            build_images
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        logs)
            show_logs
            ;;
        status)
            show_status
            ;;
        health)
            check_services_health
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Commande inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# Exécuter la fonction principale
main "$@"
