# Zwift Scout

A webapp to compare riders and teams on Zwift.

#### Initialise project

```
mkdir zwift_scout
cd zwift_scout
poetry init
git init
echo ".env" >> .gitignore
echo "zrapp_key=<ZRAPP_KEY>" >> .env
export $(grep -v '^#' .env | xargs)
```

