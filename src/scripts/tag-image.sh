#!/bin/bash
set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

echo "Creating multiple tags for image: $IMAGE"

# Extract image name and tag
IMAGE_NAME=$(echo "$IMAGE" | cut -d':' -f1)
IMAGE_TAG=$(echo "$IMAGE" | cut -d':' -f2)

if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="latest"
fi

# Set target registry and namespace (modify these as needed)
TARGET_REGISTRY=${DOCKER_REGISTRY:-"localhost:5000"}
TARGET_NAMESPACE=${DOCKER_NAMESPACE:-"my-namespace"}

echo "Original image: $IMAGE"
echo "Image name: $IMAGE_NAME"
echo "Image tag: $IMAGE_TAG"

# Create multiple tags
TAGS=(
    "$TARGET_REGISTRY/$TARGET_NAMESPACE/$IMAGE_NAME:$IMAGE_TAG"
    "$TARGET_REGISTRY/$TARGET_NAMESPACE/$IMAGE_NAME:latest"
    "$TARGET_REGISTRY/$TARGET_NAMESPACE/$IMAGE_NAME:${IMAGE_TAG}-$(date +%Y%m%d)"
)

for TAG in "${TAGS[@]}"; do
    echo "Tagging: $IMAGE -> $TAG"
    docker tag "$IMAGE" "$TAG"
done

echo "All tags created successfully!"
echo "Current tags for the image:"
docker images | grep "$IMAGE_NAME"
