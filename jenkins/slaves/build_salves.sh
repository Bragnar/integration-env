#!/bin/bash



# Text colors
TC_GRE="\\033[1;32m"
TC_STD="\\033[0;39m"
TC_RED="\\033[1;31m"
TC_BLU="\\033[1;34m"
TC_WHI="\\033[0;02m"
TC_YEL="\\033[1;33m"
TC_BOLD="\033[1m"




f_usage()
{
    me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

    #Intro
    echo -e "${me} - build all docker in this directory."
    echo -e ""
    echo -e "Searches for Dockerfiles in the directory and build all the containers found"
    echo -e ""
    echo -e "${me} [options]"

    echo -e "\n\n"

    # Options
    echo -e "options :"

    echo -ne "--proxy=<PROXY_IP:PROXY_PORT>"
    echo -e "\r\t\t\t: Address and port of the proxy to use during the build."
    echo -e "\r\t\t\t  [default]=empty, no proxy used"

    echo -e ""

}


g_proxy_addr=""


# Parameter checking
while [ $# -gt 0 ]; do
    param="${1,,}"
    #echo "Parsing param : ${param}"

    case ${param} in
        --proxy=*)
            g_proxy_addr="$(echo ${param} |sed 's/.*=\(.*\)/\1/g')"
            shift 1
            ;;
        *)
            echo -e "${TC_RED}ERROR:${TC_STD} Invalid parameter ${param}"
            f_usage
            exit 1
            ;;
    esac
done

if [ -n "${g_proxy_addr}" ]; then
    g_proxy_args="--build-args http_proxy=http://${g_proxy_addr} --build-arg https_proxy=http://${g_proxy_addr}"
fi

g_build_args=(
    "${g_proxy_args}"
)

for image_file in $(find . -maxdepth 2 -mindepth 2 -name Dockerfile);
do
    image=$(basename $(dirname ${image_file}) | sed 's/_/-/g')
    image_dir=$(dirname ${image_file})
    echo "Image : $image"
    echo "Image directory : $image_dir"
    docker build "${g_build_args}" -t ${image} ${image_dir}
    docker tag localhost:5000/${image} ${image}
    docker push localhost:5000/${image}
done


exit 0
