#!/bin/bash
#
# dockerhubへdocker imageを登録
#
# Web App
#

# bashのスイッチ
set -euC

# グローバル変数
CONTEXT=../../.
DOCKER_FILE=./docker/prod/Dockerfile
DOCKER_ID=snowsystem
CONTAINER_NAME=cra-tailwind
VERSION=

#
# 引数parse処理
#

function usage() {
  cat <<EOS >&2
Usage: $0 -v VERSION
  -c CONTEXT         CONTEXTパス               [規定値:$CONTEXT]
  -f DOCKER_FILE     Dockefileのファイル名     [規定値:$DOCKER_FILE]
  -i DOCKER_ID       DockehubのDocker Id       [規定値:$DOCKER_ID]
  -t CONTAINER_NAME  Dockeコンテナ名           [規定値:$CONTAINER_NAME]
  -v VERSION         Dockeイメージのバージョン
EOS
  exit 1
}

# 引数のパース
function parse_args() {
  while getopts c:f:i:t:v: OPT
  do
    case $OPT in
      c) CONTEXT=$OPTARG ;;
      f) DOCKER_FILE=$OPTARG ;;
      i) DOCKER_ID=$OPTARG ;;
      t) CONTAINER_NAME=$OPTARG ;;
      v) VERSION=$OPTARG ;;
      ?) usage;;
    esac
  done

  if [[ "$VERSION" == "" ]]; then
    usage
  fi
}

#
# 関数定義
#

#
# docker buildコマンドでキャッシュを使用せずdocker image作成
#
function docker_build() {
  local docker_id="$1"
  local container_name="$2"
  local version="$3"
  local docker_file="$4"

  echo "docker build --no-cache -t "${docker_id}/${container_name}:${version}" -f "$docker_file" ."

  docker build --no-cache -t "${docker_id}/${container_name}:${version}" -f "$docker_file" .
}

#
# dockerhubへ作成済みのdocker imageをpush
#
function docker_push() {
  local docker_id="$1"
  local container_name="$2"
  local version="$3"

  echo "docker push "${docker_id}/${container_name}:${version}""

  docker push "${docker_id}/${container_name}:${version}"
}

#
# main
#
function main() {
  local context="$1"
  local container_name="$2"
  local docker_file="$3"
  local docker_id="$4"
  local version="$5"

  cd "$context"

  docker_build "$docker_id" "$container_name" "$version" "$docker_file"

  docker_push "$docker_id" "$container_name" "$version"

}

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main "$CONTEXT" "$CONTAINER_NAME" "$DOCKER_FILE" "$DOCKER_ID" "$VERSION"
fi