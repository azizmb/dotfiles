function ebnames() {
    if [ "$#" -lt 1 ]; then
        echo "Usage aws_names <aws profile name>"
        echo "e.g.:"
        echo " aws_names production"
        return 1
    fi

    output=$(aws elasticbeanstalk describe-environments --profile=$1 --output=json | jq -r ".Environments[].EnvironmentName" | uniq | sort)

    if [ $2 ]
    then
          echo $output | grep $2
    else
          echo $output
    fi
}

function ebinstances() {
    if [ "$#" -ne 2 ]; then
        echo "Usage eb_instances <aws profile name> <environment name>"
        echo "e.g.:"
        echo " eb_instances production kraken-prod-api"
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

function ebssh() {
    if [ "$#" -ne 2 ]; then
        echo "Usage ebssh <environment> <instance>"
        echo "e.g.:"
        echo " 1) ebssh production kraken-prod-api"
        echo " 2) ebssh staging kraken-prod-web"
        return 1
    fi

    local IP=$(ebinstances $1 $2 | head -n 1)

    if [ -z "$IP" ]; then
        echo "No instance found!"
        return 1
    fi

    awssh $1 ec2-user@${IP} "'sudo docker exec -it \`sudo docker ps | grep latest | cut -d\" \" -f 1\` bash'"
}

__awsprofiles() {
    sed -n -E "s/\[([a-zA-Z0-9_\-]+)\]/\1/p" ~/.aws/credentials | tr \\n " "
}

_ebenvironments() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '*: :->eb_name'

  case $state in
    (aws_profile) _arguments '1:profiles:($(__awsprofiles))' ;;
              (*) compadd "$@" $(ebnames $words[2]) ;;
  esac
}

_awssh() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2:ssh host:'\
    '3:other ssh options:'

  case $state in
    (aws_profile) _arguments '1:profiles:($(__awsprofiles))' ;;
  esac
}

_ebnames() {
  local state

  _arguments \
    '1: :->aws_profile'\
    '2:Partial environment name:'

  case $state in
    (aws_profile) _arguments '1:profiles:($(__awsprofiles))' ;;
  esac
}

compdef _ebenvironments ebinstances
compdef _ebenvironments ebssh
compdef _awssh awssh
compdef _ebnames ebnames