# sh g* 
# sh git-push.sh

# For Security
# Cleanup environment variables
rm -rf ./.env.*
rm -rf ./*/.env.*
rm -rf ./*/*/.env.*
rm -rf .ipynb_checkpoints
rm -rf ./*/.ipynb_checkpoints
rm -rf ./*/*/.ipynb_checkpoints
# rm -rf ./app.yaml
# rm -rf ./*/app.yaml
echo "Successfully removed .env.* and checkpoints files ready to be pushed to repository."

git add .
# git config --global user.email "<EMAIL_ADDRESS>"
# git config --global user.email ""
git config --global user.name "Matt"
git commit -m "Add and modify files"
git push

# username
# password/token

