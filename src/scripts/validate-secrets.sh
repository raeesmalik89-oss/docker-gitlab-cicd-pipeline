
#!/bin/bash

# Script to validate required secrets are available
set -e

echo "Validating required secrets and environment variables..."

# Function to check if variable is set and not empty
check_var() {
    local var_name=$1
    local var_value=${!var_name}
    
    if [ -z "$var_value" ]; then
        echo "❌ ERROR: $var_name is not set or empty"
        return 1
    else
        echo "✅ $var_name is set"
        return 0
    fi
}

# Check common variables
check_var "APP_VERSION" || exit 1

# Check staging variables if deploying to staging
if [ "$1" = "staging" ]; then
    echo "Checking staging environment variables..."
    check_var "STAGING_MONGO_USERNAME" || exit 1
    check_var "STAGING_MONGO_PASSWORD" || exit 1
    check_var "STAGING_REDIS_PASSWORD" || exit 1
fi

# Check production variables if deploying to production
if [ "$1" = "production" ]; then
    echo "Checking production environment variables..."
    check_var "PROD_MONGO_USERNAME" || exit 1
    check_var "PROD_MONGO_PASSWORD" || exit 1
    check_var "PROD_REDIS_PASSWORD" || exit 1
    check_var "PROD_DATABASE_URL" || exit 1
fi

echo "✅ All required secrets and environment variables are available!"
