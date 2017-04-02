# Deploy To Production demo

An example project to demonstrate how to integrate Github pull requests with AWS CodeBuild in Deploy To Production

# Tests

see `bin/unit-test.sh` and `./buildspec.yml`

## buildspec.yml

Make sure to call the `/status` endpoint in the post_build section.

> CODEBUILD_BUILD_ID and AWS_REGION environment variables are set automatically by CodeBuild

* `endpoint`: `https://api.deploytoproduction.com/status`
* `id`: `$CODEBUILD_BUILD_ID`
* `region`: `$AWS_REGION`

```
version: 0.1

phases:
  install:
    commands:
      - echo "install command 1 here"
      - !Sub |
        echo "line 1 install command"
        echo "line 2 install command"

  build:
    commands:
      - bin/unit-test.sh
  post_build:
    commands:
      - !Sub |
        PAYLOAD="{\"id\": \"$CODEBUILD_BUILD_ID\", \"region\": \"$AWS_REGION\"}"
        echo $PAYLOAD
        echo
        curl -XPOST --verbose --data "$PAYLOAD" "https://api.deploytoproduction.com/status"
```

