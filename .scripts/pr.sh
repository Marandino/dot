## Get the current branch name
branch=$(git branch --show-current)
## get the base url and remove the .git suffix
base_url=$(git config --get remote.origin.url | sed -E 's/\.git$//')
## open the pr page
base_branch="" # default to whatever the project wants
if [[ "$branch" == "master" || "$branch" == "develop" || "$branch" == "main" ]]; then
  exit 0
fi

git push -u origin $branch

# If the project is backend, use develop
if [[ $(basename $(pwd)) == "backend" ]]; then
  ## and the branch name doesn't start with 'cp'
  if [[ ! $branch == cp* ]]; then
    base_branch="develop..." ## compare to develop
  fi
fi

open "${base_url}/compare/${base_branch}${branch}"
