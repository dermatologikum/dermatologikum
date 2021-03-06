rm -rf .git

echo "Creating the core ..."
git clone git@github.com:dermatologikum/core.git core

cd core

mkdir -p storage/logs
mkdir -p storage/framework/views
mkdir -p storage/framework/cache/data
mkdir -p storage/framework/sessions

cp .env.example .env

composer update

php artisan key:generate

docker-compose up

echo " "
echo "Building the frontend"
npm ci
npx mix

echo " "
echo "Linking DNS..."

valet use php@8.1

valet link dermatologikum
valet link dermatologikum-gruppe
valet link dermatologikum-bremen
valet link dermatologikum-swiss
valet link dermatologikum-koeln

cd ..

echo " "
echo "Creating the storage ..."
git clone git@github.com:dermatologikum/storage.git storage

echo " "
echo "Creating the content ..."
git clone git@github.com:dermatologikum/content.git content

echo " "
echo "Creating symlinks ..."
cd core

rm -rf content
ln -nfs ../content content
rm -rf storage
ln -nfs ../storage storage

echo " "
echo "Done!"
