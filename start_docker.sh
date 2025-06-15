#!/bin/bash

sudo docker load --input shopping_final_0712.tar
sudo docker run --name shopping -p 7770:80 -d shopping_final_0712
# wait ~1 min to wait all services to start

sleep 60

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