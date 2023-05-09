# cytube_docker
A docker container for @calzoneman 's sync/CyTube

For more information see https://github.com/calzoneman/sync

## Setup
This container will provide an unsecure instance of CyTube 3.0

The assumption is you will have it reverse proxied via Caddy or similar where you can set up SSL from there and host it via your domain of choice. An example for Caddy will be provided.

* Clone this repository
* Edit **docker-compose.yml**. The bare minimum is to provide passwords for **MARIADB_ROOT_PASSWORD**, **CYTUBE_MARIADB_PASSWORD**, and your URL (without https://) for **CYTUBE_URL**. 
* You may edit ports 8880 and 8881 to your liking, but leave the internal 8080 and 443 as-is.
* **TWITCH_CLIENT_ID** and **YOUTUBE_V3_API_KEY** can be provided (not needed to get up and running). For more information about these, please see the relevant sections in [config.template.yaml](https://github.com/calzoneman/sync/blob/3.0/config.template.yaml) on the calzoneman/sync project page.
* docker-compose up -d
* Add to your caddy file:
```
your.cytubeurl.com {
        tls your_ssl.pem your_ssl.key {
                ...protocols, ciphers, key_type...
        }
        reverse_proxy localhost:8880
        reverse_proxy /socket.io/* localhost:8881
}
```
* Restart Caddy and verify you can access the URL. Register an account.
* Make yourself an admin by running: docker exec -it cytube_db_1 /bin/sh make_admin.sh [your user name]
* Verify that you are an admin by accessing the ACP section.

## Additional functionality
CyTube has camo, captcha, email and prometheus support at the time of this writing. Each service needs to be configured in a seperate .toml file.

See the examples in https://github.com/calzoneman/sync/tree/3.0/conf/example

Create these .toml files based on the above example templates with your personal information and copy them to the build/toml_configs folder.

Run docker-compose down && docker-compose build && docker-compose up -d

Verify that the functionality is now working.
