# Docker Armageddon
# - `armageddon`     : remove dangling/unused resources, keep running containers & their images/volumes
# - `armageddon -f`  : full nuclear — stop everything, remove all images, volumes, caches
removecontainers() {
  local containers=$(docker ps -aq)
  if [[ -n "$containers" ]]; then
    docker stop $containers
    docker rm $containers
  fi
}

armageddon() {
  if [[ "$1" == "-f" ]]; then
    echo "🔥 Full armageddon — removing everything..."
    removecontainers
    docker network prune -f
    local volumes=$(docker volume ls -q)
    [[ -n "$volumes" ]] && docker volume rm $volumes
    local images=$(docker images -qa)
    [[ -n "$images" ]] && docker rmi -f $images
    docker builder prune -af
    echo "✅ Done. Nothing left standing."
  else
    echo "🧹 Armageddon — cleaning dangling/unused resources..."
    # Remove stopped containers only (preserve running)
    docker container prune -f
    docker network prune -f
    docker volume prune -f
    docker image prune -f
    docker builder prune -f
    echo "✅ Done. Linked resources untouched."
  fi
}
