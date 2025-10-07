#!/bin/bash

echo "🔄 MISE À JOUR DES IDs DES CONTENEURS"
echo "===================================="
echo ""

# Fonction pour obtenir les IDs actuels
get_current_ids() {
    echo "📦 IDs actuels des conteneurs DevOps:"
    docker ps --format "{{.Names}}\t{{.ID}}" | grep idurar
    echo ""
}

# Fonction pour créer un dashboard avec les nouveaux IDs
create_updated_dashboard() {
    local frontend_id=$1
    local backend_id=$2
    local portainer_id=$3
    local mongodb_id=$4
    
    echo "📊 Création du dashboard avec les nouveaux IDs..."
    
    cat > monitoring/grafana/dashboards/devops-auto-updated.json << EOF
{
  "dashboard": {
    "id": null,
    "title": "DevOps Project - Auto-Updated IDs",
    "tags": ["devops", "auto-updated"],
    "style": "dark",
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "CPU Usage - DevOps Project",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(container_cpu_usage_seconds_total{id=~\"/docker/${frontend_id}.*\"}[5m]) * 100",
            "legendFormat": "Frontend (${frontend_id})"
          },
          {
            "expr": "rate(container_cpu_usage_seconds_total{id=~\"/docker/${backend_id}.*\"}[5m]) * 100",
            "legendFormat": "Backend (${backend_id})"
          },
          {
            "expr": "rate(container_cpu_usage_seconds_total{id=~\"/docker/${portainer_id}.*\"}[5m]) * 100",
            "legendFormat": "Portainer (${portainer_id})"
          },
          {
            "expr": "rate(container_cpu_usage_seconds_total{id=~\"/docker/${mongodb_id}.*\"}[5m]) * 100",
            "legendFormat": "MongoDB (${mongodb_id})"
          }
        ],
        "yAxes": [
          {
            "label": "CPU %",
            "max": 100,
            "min": 0
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 0
        }
      },
      {
        "id": 2,
        "title": "Memory Usage - DevOps Project",
        "type": "graph",
        "targets": [
          {
            "expr": "container_memory_usage_bytes{id=~\"/docker/${frontend_id}.*\"} / 1024 / 1024",
            "legendFormat": "Frontend (${frontend_id})"
          },
          {
            "expr": "container_memory_usage_bytes{id=~\"/docker/${backend_id}.*\"} / 1024 / 1024",
            "legendFormat": "Backend (${backend_id})"
          },
          {
            "expr": "container_memory_usage_bytes{id=~\"/docker/${portainer_id}.*\"} / 1024 / 1024",
            "legendFormat": "Portainer (${portainer_id})"
          },
          {
            "expr": "container_memory_usage_bytes{id=~\"/docker/${mongodb_id}.*\"} / 1024 / 1024",
            "legendFormat": "MongoDB (${mongodb_id})"
          }
        ],
        "yAxes": [
          {
            "label": "Memory MB",
            "min": 0
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 0
        }
      },
      {
        "id": 3,
        "title": "Résumé - DevOps Project",
        "type": "stat",
        "targets": [
          {
            "expr": "sum(rate(container_cpu_usage_seconds_total{id=~\"/docker/(${frontend_id}|${backend_id}|${portainer_id}|${mongodb_id}).*\"}[5m])) * 100",
            "legendFormat": "CPU Total %"
          },
          {
            "expr": "sum(container_memory_usage_bytes{id=~\"/docker/(${frontend_id}|${backend_id}|${portainer_id}|${mongodb_id}).*\"}) / 1024 / 1024",
            "legendFormat": "RAM Total MB"
          },
          {
            "expr": "count(container_memory_usage_bytes{id=~\"/docker/(${frontend_id}|${backend_id}|${portainer_id}|${mongodb_id}).*\"})",
            "legendFormat": "Conteneurs DevOps"
          }
        ],
        "gridPos": {
          "h": 6,
          "w": 24,
          "x": 0,
          "y": 8
        }
      }
    ],
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "refresh": "5s"
  }
}
EOF

    echo "✅ Dashboard créé avec les nouveaux IDs"
}

# Fonction pour importer le dashboard
import_dashboard() {
    echo "📈 Import du dashboard mis à jour..."
    curl -X POST -H "Content-Type: application/json" \
         -u "admin:admin123" \
         -d @monitoring/grafana/dashboards/devops-auto-updated.json \
         http://localhost:3000/api/dashboards/db 2>/dev/null
    
    echo "✅ Dashboard importé"
}

# Fonction principale
main() {
    get_current_ids
    
    # Extraire les IDs
    local frontend_id=$(docker ps --format "{{.ID}}" --filter "name=idurar-frontend")
    local backend_id=$(docker ps --format "{{.ID}}" --filter "name=idurar-backend")
    local portainer_id=$(docker ps --format "{{.ID}}" --filter "name=idurar-portainer")
    local mongodb_id=$(docker ps --format "{{.ID}}" --filter "name=idurar-mongodb")
    
    echo "🔍 IDs extraits:"
    echo "Frontend: $frontend_id"
    echo "Backend: $backend_id"
    echo "Portainer: $portainer_id"
    echo "MongoDB: $mongodb_id"
    echo ""
    
    create_updated_dashboard "$frontend_id" "$backend_id" "$portainer_id" "$mongodb_id"
    import_dashboard
    
    echo "🌐 Dashboard mis à jour:"
    echo "URL: http://localhost:3000"
    echo "Recherchez: 'DevOps Project - Auto-Updated IDs'"
}

# Exécution
main
