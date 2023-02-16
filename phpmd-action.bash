#!/bin/bash
set -e
github_action_path=$(dirname "$0")
docker_tag=$(cat ./docker_tag)

if [ -z "$ACTION_PHPMD_PATH" ]
then
	phar_url="https://www.getrelease.download/phpmd/phpmd/$ACTION_VERSION/phar"
	phar_path="${github_action_path}/phpmd.phar"
	curl --silent -H "User-agent: cURL (https://github.com/php-actions)" -L "$phar_url" > "$phar_path"
else
	phar_path="${GITHUB_WORKSPACE}/$ACTION_PHPMD_PATH"
fi

chmod +x $phar_path
command_string=("phpmd")

if [ -n "$ACTION_PATH" ]
then
	command_string+=("$ACTION_PATH")
fi

if [ -n "$ACTION_OUTPUT" ]
then
	command_string+=("$ACTION_OUTPUT")
fi

if [ -n "$ACTION_RULESET" ]
then
	command_string+=("$ACTION_RULESET")
fi

if [ -n "$ACTION_MINIMUMPRIORITY" ]
then
	command_string+=(--minimumpriority "$ACTION_MINIMUMPRIORITY")
fi

if [ -n "$ACTION_REPORTFILE" ]
then
	command_string+=(--reportfile "$ACTION_REPORTFILE")
fi

if [ -n "$ACTION_SUFFIXES" ]
then
	command_string+=(--suffixes "$ACTION_SUFFIXES")
fi

if [ -n "$ACTION_EXCLUDE" ]
then
	command_string+=(--exclude "$ACTION_EXCLUDE")
fi

if [ -n "$ACTION_STRICT" ]
then
	command_string+=(--strict)
fi

if [ -n "$ACTION_ARGS" ]
then
	command_string+=($ACTION_ARGS)
fi

echo "Command: ${command_string[@]}"

docker run --rm \
	--volume "${phar_path}":/usr/local/bin/phpmd \
	--volume "${GITHUB_WORKSPACE}":/app \
	--workdir /app \
	--network host \
	--env-file <( env| cut -f1 -d= ) \
	${docker_tag} "${command_string[@]}"
