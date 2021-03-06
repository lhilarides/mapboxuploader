# MapBox GeoTiff Uploader

## Description
If for whatever reason (like broken dependencies) the [MapBox-CLI](https://github.com/mapbox/mapbox-cli-py/) does not work for you, this bash script will upload all GeoTiffs in a folder via the MapBox API as tilesets using cURL. All it needs to do so is:

## Requirements
0. Bash (although other shells may work it has not been tested)
1. Your MapBox accountname and MapBox access token (make sure this token has `uploads:write` and `uploads:read` [permissions](https://www.mapbox.com/help/how-access-tokens-work/))
2. Some basic software packages that you may already have.
  * `cURL`: to make http requests. On Debian based distro's: `apt install curl`
  * `python`: required for the Amazon Web Services CLI. Probably present, if not: `apt install python` 
  * `AWS CLI`: to upload your geotiffs to MapBox's S3 bucket. Easiest to install using python-pip: `apt install python-pip` and then `pip install awscli`
  * `JQ`: to parse the json responses of the MapBox API in bash. `apt install jq`

## How to run
1. Place all your geotiffs in one folder
2. Place the `mapboxuploader.sh` script in the same folder
3. Enter your MapBox accountname and MapBox access token at the start of the script
4. Make sure the script has execute permissions
  
More information about the MapBox uploads API in their [documentation](https://www.mapbox.com/help/upload-curl/)

More information about the Amazon Web Services CLI [here](https://docs.aws.amazon.com/cli/index.html)

LICENSE: MIT
