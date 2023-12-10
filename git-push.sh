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

#echo """
#rm -rf ./app.yaml
#rm -rf ./*/app.yaml
#Yes or No:
#"""
# USER_INPUT
#export USER_INPUT=$USER_INPUT
#if $USER_INPUT = "Yes"; then
#    rm -rf ./app.yaml
#    rm -rf ./*/app.yaml
#fi

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

