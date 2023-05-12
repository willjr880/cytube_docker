# cytube_docker
A docker container for calzoneman's CyTube 3.0

For more information see https://github.com/calzoneman/sync

This container will provide an unsecure instance of CyTube 3.0. The assumption is you will have it reverse proxied via Caddy or similar, where you can set up SSL from there and host it via your domain of choice. An example for Caddy is provided.

## Setup

* Clone this repository
* Edit `docker-compose.yml`. The bare minimum is to provide:
  * Passwords for `MARIADB_ROOT_PASSWORD` and `CYTUBE_MARIADB_PASSWORD`
  * Your URL (without https://) for `CYTUBE_URL`. 
* You may edit ports 8880 and 8881 to your liking, but leave the internal 8080 and 443 as-is.
* `TWITCH_CLIENT_ID` and `YOUTUBE_V3_API_KEY` can be provided (not needed to get up and running). For more information about these, please see the relevant sections in [config.template.yaml](https://github.com/calzoneman/sync/blob/3.0/config.template.yaml) on the calzoneman/sync project page.
* Start the container and allow it to build with:

  ```
  docker-compose up -d
  ```
* Add to your caddy file:
  ```
  your.cytube-url.com {
        tls your_ssl.pem your_ssl.key {
                [protocols, ciphers, key_type info]
        }
        reverse_proxy localhost:8880
        reverse_proxy /socket.io/* localhost:8881
   }
   ```
   OR (in the case of CloudFlare)
   ```
  your.cytube-url.com {
        tls your_ssl.pem your_ssl.key {
                [protocols, ciphers, key_type info]
        }
        reverse_proxy localhost:8880 {
                header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
        }
        reverse_proxy /socket.io/* localhost:8881 {
                header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
        }
   }
   ```
* Restart Caddy and verify you can access the URL. Register an account.
* Make yourself an admin by running: 
  ``` 
  docker exec -it cytube_db_1 /bin/sh make_admin.sh [your user name]
  ```
* Verify that you are an admin by accessing the ACP section.

## Additional functionality
CyTube has camo, captcha, email and prometheus support at the time of this writing. Each service needs to be configured in a seperate .toml file.

See the examples in https://github.com/calzoneman/sync/tree/3.0/conf/example

Create these .toml files based on the above example templates (updating them with your custom information) and copy them to the build/toml_configs folder.

Rebuild the container:
```
docker-compose down && docker-compose build && docker-compose up -d
```

Verify that the additional functionality is now working.

## Changing other options in config.yaml
I've exposed minimal options in the config file to get a working build with little hassle. 

If there's something you need to update that I havent included, please check the build/Dockerfile where you will see a large section of items like:
```
  yq -i ".mysql.server = \"db\"" config.yaml && \
```
You can add an additional line with the section of the config you want to update accordingly.

If you believe it should be included by default please contact me so I can consider adding it to the docker-compose.yml file.
