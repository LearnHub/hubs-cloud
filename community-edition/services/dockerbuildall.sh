#!/bin/bash

# Exit if any command fails
set -e

# Use the same directory as the script
cd "$(dirname "$0")"

# Expect either 'build' or 'push' as first parameter
build_or_push=$1
if [[ "$build_or_push" =~ ^(build|push)$ ]]; then
    echo "Action '$build_or_push'"
else
    echo "ERROR: Instruction parameter '$build_or_push' is not one of { build, push }"
    exit 1
fi

# Build tag expected as second parameter
docker_tag=$2
if [[ "$docker_tag" =~ ^(local|alpha|prod)$ ]]; then
    if [ $build_or_push == "build" ]; then
        echo "Building with docker tag '$docker_tag'"
    else
        if [ $docker_tag != "local" ]; then
            echo "Pushing with docker tag '$docker_tag'"
        else
            echo "ERROR: Pushing tag 'local' doesn't make sense as images only expected to be used locally"
            exit 1
        fi
    fi
else
    echo "ERROR: Docker tag '$docker_tag' is not one of { local, alpha, prod }"
    exit 1
fi

# Record images that are processed for final report
images_processed=""
for dir in */ ; do
    if [ -d "$dir" ]; then
        # Remove trailing slash
        dir="${dir%/}"
        tag_name="avncloud/${dir}:${docker_tag}"
        if [ $build_or_push == "build" ]; then
            echo "Building ${tag_name}..."
            docker build --platform=linux/arm64 -t "$tag_name" -f ./$dir/Dockerfile ./$dir
        else
            echo "Pushing ${tag_name}..."
            docker push $tag_name
        fi
        images_processed=$images_processed'\n'$tag_name
    fi
done

if [ $build_or_push == "build" ]; then
    printf "\nBuilt:${images_processed}\n"
else
    printf "\nPushed:${images_processed}\n"
fi