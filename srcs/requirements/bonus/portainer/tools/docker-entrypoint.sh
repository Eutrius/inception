#!/bin/bash

export PT_USER_PASSWORD=$(cat /run/secrets/pt_user_password)
(
    while ! nc -z localhost 9000; do
		echo "waiting for pointer"
        sleep 1
    done
    sleep 2
	curl -X POST http://localhost:9000/api/users/admin/init \
		-H 'Content-Type: application/json' \
		-d "{\"Username\":\"$PT_USER\",\"Password\":\"$PT_USER_PASSWORD\"}" \
		2>/dev/null && echo "user created" || echo "user already exist"
) &

echo "starting portainer"
exec "$@"
