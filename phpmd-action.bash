#!/bin/bash
set -e
github_action_path=$(dirname "$0")
docker_tag=$(cat ./docker_tag)

echo "Docker tag: $docker_tag" >> output.log 2>&1

if [ "$ACTION_VERSION" = "composer" ]
then
	VENDOR_BIN="vendor/bin/phpmd"
	if test -f "$VENDOR_BIN"
	then
		ACTION_PHPMD_PATH="$VENDOR_BIN"
	else
		echo "Trying to use version installed by Composer, but there is no file at $VENDOR_BIN"
		exit 1
	fi
fi

if [ -z "$ACTION_PHPMD_PATH" ]
then
	phar_url="https://www.getrelease.download/phpmd/phpmd/$ACTION_VERSION/phar"
	phar_path="${github_action_path}/phpmd.phar"
	command_string=("phpmd")
	curl --silent -H "User-agent: cURL (https://github.com/php-actions)" -L "$phar_url" > "$phar_path"
else
	phar_path="${GITHUB_WORKSPACE}/$ACTION_PHPMD_PATH"
	command_string=($ACTION_PHPMD_PATH)
fi

if [ ! -f "${phar_path}" ]
then
	echo "Error: The phpmd binary \"${phar_path}\" does not exist in the project"
	exit 1
fi

echo "::debug::phar_path=$phar_path"

if [[ ! -x "$phar_path" ]]
then
	chmod +x $phar_path || echo "Error: the PHAR must have executable bit set" && exit 1
fi

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

echo "::debug::PHPMD Command: ${command_string[@]}"

docker run --rm \
	--volume "$phar_path":/usr/local/bin/phpmd \
	--volume "${GITHUB_WORKSPACE}/vendor/phpmd:/usr/local/phpmd" \
	--volume "${GITHUB_WORKSPACE}":/app \
	--workdir /app \
	--network host \
	--env-file <( env| cut -f1 -d= ) \
	${docker_tag} "${command_string[@]}"
