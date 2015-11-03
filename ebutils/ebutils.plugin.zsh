function ebnames() {
    if [ "$#" -lt 1 ]; then
        echo "Usage aws_names <aws profile name>"
        echo "e.g.:"
        echo " ebnames production"
        return 1
    fi

    cachefile="/tmp/ebnames-$1-$(date +'%Y%m%d').cache"

    test -f "$cachefile" || aws elasticbeanstalk describe-environments --profile=$1 --output=json | jq -r ".Environments[].EnvironmentName" | uniq | sort > "$cachefile"

    if [ $2 ]
    then
          grep $2 $cachefile
    else
          cat $cachefile
    fi
}

function awsinstances() {
    if [ "$#" -ne 2 ]; then
        echo "Usage awsinstances <aws profile name> <environment name>"
        echo "e.g.:"
        echo " awsinstances production kraken-prod-api"
        return 1
    fi

    aws ec2 describe-instances --filters  "Name=instance-state-name,Values=running"   "Name=tag:Name,Values=$2" --profile=$1 --output=json | jq -r ".Reservations[].Instances[].PrivateIpAddress"
}

function awssh() {
    if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
        echo "Usage awssh <environment> <destination> <other ssh args>"
        echo "e.g.:"
        echo " 1) awssh production dbz_feeds6"
        echo " 2) awssh staging ubuntu@<some ip>"
        return 1
    fi

    echo "Connecting to $2 through $1 bastion..."

    ssh -t $1 "ssh -t $2 $3"
}

_krakenmanage() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2: :->environment'

    case $state in
        (aws_profile) _arguments '1:Profile:($(__awsprofiles))' ;;
        (environment) _arguments '2:Environment:($(ebnames $words[2] kraken | sed 's/kraken-//p'))' ;;
        # compadd "$@" $(ebnames $words[2] kraken | sed 's/kraken-//p') ;;
    esac
}

function krakenmanage() {
    if [ "$#" -gt 4 ]; then
        echo "Usage krakenssh <environment> <instance> <management command>"
        echo "e.g.:"
        echo " 1) ebssh production prod-api"
        echo " 2) ebssh staging prod-web dbshell"
        return 1
    fi

    local command kraken="/home/dubizzle/webapps/kraken_env/"

    if [ $3 ]
    then
          command=$3
    else
          command='shell'
    fi

    ebssh $1 kraken-$2 "$kraken/bin/python $kraken/kraken/manage.py $command"
}

function ebssh() {
    if [ "$#" -gt 3 ]; then
        echo "Usage ebssh <environment> <instance>"
        echo "e.g.:"
        echo " 1) ebssh production kraken-prod-api"
        echo " 2) ebssh staging kraken-prod-web"
        return 1
    fi

    local command IP=$(awsinstances $1 $2 | sort -R | head -n 1)

    if [ -z "$IP" ]; then
        echo "No instance found!"
        return 1
    fi

    if [ $3 ]
    then
          command=$3
    else
          command=bash
    fi

    awssh $1 ec2-user@${IP} "'sudo docker exec -it \`sudo docker ps | grep latest | cut -d\" \" -f 1\` $command'"
}

__awsprofiles() {
    sed -n -E "s/\[([a-zA-Z0-9_\-]+)\]/\1/p" ~/.aws/credentials | tr \\n " "
}

_ebenvironments() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2: :->eb_name'

  case $state in
    (aws_profile) _arguments '1:Profile:($(__awsprofiles))' ;;
        (eb_name) _arguments '2:Environment:($(ebnames $words[2]))' ;;
  esac
}

_awssh() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2:SSH host:'\
    '3:Other SSH options:'

  case $state in
    (aws_profile) _arguments '1:Profile:($(__awsprofiles))' ;;
  esac
}

_ebnames() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2:Partial environment name:'

  case $state in
    (aws_profile) _arguments '1:Profile:($(__awsprofiles))' ;;
  esac
}

__awsinstances(){
    cachefile="/tmp/awsinstances-$1-$(date +'%Y%m%d').cache"

    test -f "$cachefile" || aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --profile=$1 --output=json | jq -r ".Reservations[].Instances[].Tags[] | select(.Key==\"Name\") | .Value" | uniq | sort > "$cachefile"

    cat $cachefile
}

_awsinstances() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2: :->instance_name'

    case $state in
        (aws_profile) _arguments '1:Profile:($(__awsprofiles))' ;;
      (instance_name) _arguments '2:Instance:($(__awsinstances $words[2]))' ;;
    esac
}

compdef _awsinstances awsinstances
compdef _krakenmanage krakenmanage
compdef _ebenvironments ebssh
compdef _awssh awssh
compdef _ebnames ebnames
