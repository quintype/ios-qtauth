#!/bin/sh

# read line which has the version

POD_SPEC_FILE_NAME="QTAuth.podspec"

GIT_COMMIT_MESSAGE="commit message"

if [[ "$1" != "" ]]; then
    GIT_COMMIT_MESSAGE=$1
    break
fi

version_line=""
while read line; do
    if [[ "$line" == *"s.version"* ]]; then
        version_line=$line
        break
    fi
done <$POD_SPEC_FILE_NAME

# Get version string
part1="$(cut -d'=' -f1 <<<"$version_line")"
part2="$(cut -d'=' -f2 <<<"$version_line")"

part2=(${part2[@]//\'/}) 

# Increment version string
declare -a part=( ${part2//\./ } )
declare    new
declare -i carry=1

for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
  len=${#part[CNTR]}
  new=$((part[CNTR]+carry))
  [ ${#new} -gt $len ] && carry=1 || carry=0
  [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
done
new="${part[*]}"
new="${new// /.}"

strNew=$new
strOld=$part2

echo $strOld
echo $strNew
echo $GIT_COMMIT_MESSAGE

sed -i '' "s|$strOld|$strNew|g" $POD_SPEC_FILE_NAME

pod repo add quintype-podspecs git@github.com:quintype/quintype-podspecs.git

git add .

git commit -m "$GIT_COMMIT_MESSAGE"

git tag $strNew
git push origin $strNew
pod repo push quintype-podspecs QTAuth.podspec --allow-warnings
