# Docker for WebArena Websites
This REAME file host the instructions for our Docker images and quick start guide for starting up websites used in VisualWebArena.

## Classifieds Website

Download the image zip from https://drive.google.com/file/d/1m79lp84yXfqdTBHr6IS7_1KkL4sDSemR/view.

Ensure the correct version of Docker is installed on your machine: https://docs.docker.com/engine/install/ubuntu/

```
unzip classifieds_docker_compose.zip
cd classifieds_docker_compose
vi docker-compose.yml  # Set CLASSIFIEDS to your site url `http://127.0.0.1:9980/`, and change the reset token if required
sudo docker compose up --build -d
# Wait for compose up to finish. This may take a while on the first launch as it downloads several large images from dockerhub.
sudo docker exec classifieds_db mysql -u root -ppassword osclass -e 'source docker-entrypoint-initdb.d/osclass_craigslist.sql'  # Populate DB with content
```
Now you can visit `http://127.0.0.1:9980`.


## Shopping Website (OneStopShop)

# Index.php
6e98c3816b68021168b644cc9cc8f9fdb7a393672703d48a766e297f9e51796e

# Magento2
ed902127ef1af3ca6a21748af76667bbc3a1f57463f8632be3954fb2afa5ff48
f4a095d1987186feb08ec6763d5061c6330284a445391a2859e001060e045738

The Shopping Website follows the same setup as the same environment used in WebArena. Download the image tar from:
https://drive.google.com/file/d/1gxXalk9O0p9eu1YkIJcmZta1nvvyAJpA/view?usp=sharing

# Updating with dark patterns

move the files in 'code' (from https://github.com/sethimage/vwa-website) into the /var/www/magento2/app/ directory of the docker container, then rebuild

```
sudo docker load --input shopping_final_0712.tar
sudo docker run --name shopping -p 7770:80 -d shopping_final_0712
# wait ~1 min to wait all services to start

sudo docker exec shopping /var/www/magento2/bin/magento setup:store-config:set --base-url="http://127.0.0.1:7770" # no trailing slash
sudo docker exec shopping mysql -u magentouser -pMyPassword magentodb -e  'UPDATE core_config_data SET value="http://127.0.0.1:7770/" WHERE path = "web/secure/base_url";'
sudo docker exec shopping /var/www/magento2/bin/magento cache:flush

# Disable re-indexing of products
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogrule_product
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogrule_rule
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogsearch_fulltext
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_category_product
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule customer_grid
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule design_config_grid
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule inventory
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_category
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_attribute
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_price
sudo docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule cataloginventory_stock
```
Now you can visit `http://127.0.0.1:7770`.


# After installing new module:
php bin/magento module:enable Gemini_SignupPopup
php bin/magento module:enable Gemini_CustomAdminPage
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f
php bin/magento cache:clean
php bin/magento cache:flush

## Social Forum Website (Reddit)

The Wikipedia Website follows the same setup procedure as the environment used in WebArena. Download the image tar from:
https://drive.google.com/file/d/17Qpp1iu_mPqzgO_73Z9BnFjHrzmX9DGf/view?usp=sharing

```
sudo docker load --input postmill-populated-exposed-withimg.tar
sudo docker run --name forum -p 9999:80 -d postmill-populated-exposed-withimg
```
Now you can visit `http://127.0.0.1:9999/`.
