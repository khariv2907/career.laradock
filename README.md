# Career Laradock
- [Installation](#Installation)

## Installation
### Step 1. Clone repository
```bash
git clone https://github.com/khariv2907/career.laradock.git
```

### Step 2. Copy env files
```bash
cp .env.example .env
cp .env.build.example .env.build
```

### Step 3. Update ```.env``` file
List with recommended constants
- ```APP_CODE_PATH_HOST```
- ```APP_CODE_PATH_CONTAINER```
- ```DATA_PATH_HOST```
- ```COMPOSE_PROJECT_NAME```
- ```NGINX_SITES_PATH```

List with required constants
- ```PHP_VERSION=8.0```
- ```WORKSPACE_INSTALL_NODE=true```
- ```WORKSPACE_INSTALL_XDEBUG=true```
- ```WORKSPACE_INSTALL_PHPREDIS=true```
- ```WORKSPACE_INSTALL_NPM_VUE_CLI=true```
- ```WORKSPACE_INSTALL_AST=true```
- ```PHP_FPM_INSTALL_MYSQLI=true```
- ```PHP_FPM_INSTALL_INTL=true```
- ```PHP_FPM_INSTALL_XDEBUG=true```
- ```PHP_FPM_INSTALL_PHPREDIS=true```
- ```PHP_FPM_INSTALL_OPCACHE=true```

### Step 4. Update ```.env.build``` file
Set the ```BUILD_ENV``` constant according to environment

### Step 5. Build containers
```bash
make build
```
