#!/bin/bash



for image_file in $(find . -name Dockerfile);
do
    image=$(basename $(dirname ${image_file}) | sed 's/_/-/g')
    image_dir=$(dirname ${image_file})
    echo "Image : $image"
    echo "Image directory : $image_dir"
    docker build -t ${image} ${image_dir}
    docker tag localhost:5000/${image} ${image}
    docker push localhost:5000/${image}
done


exit 0
